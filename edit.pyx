# cython: infer_types=True
import pygame
import tkinter as tk
from PIL import Image, ImageTk
import time
class Screen:
	def __init__(self,x,y,rows,cols,cell_size,bg_color=(30,30,30),grid_color=(60,60,60)):
		self.x=x
		self.y=y
		self.rows=rows
		self.cols=cols
		self.pixels=[[0]* cols for i in range(rows)]
		self.cell_size=cell_size
		self.bg_color=bg_color
		self.grid_color=grid_color
		self.surface=pygame.Surface((cols*cell_size,rows*cell_size))
		self.clear()

	def clear(self):
		self.surface.fill(self.bg_color)
		self.draw_grid()
	def render(self):
		for y,z in enumerate(self.pixels):
			for x,c in enumerate(z):
				self.set_pixel(y,x,c)
	def draw_grid(self):
		for y in range(self.rows):
			for x in range(self.cols):
				rect = (x*self.cell_size, y * self.cell_size,self.cell_size,self.cell_size)
				pygame.draw.rect(self.surface,self.grid_color,rect,1)
	def set_pixel(self,row,col,stat):
		color = (255,255,255) if stat == 1 else self.bg_color
		rect = (col*self.cell_size+1, row * self.cell_size+1,self.cell_size-2,self.cell_size-2)
		pygame.draw.rect(self.surface,color,rect)
	def draw(self,screen):
		screen.blit(self.surface,(self.x,self.y))

class Widget:
	def __init__(self,parent,surface):
		self.parent=parent
		self.photo=None
		self.canvas = parent
		self.surface=surface
	def render(self):
		surf=self.surface
		img_data = pygame.surfarray.array3d(surf)
		img = Image.fromarray(img_data.swapaxes(1,0))
		self.photo= ImageTk.PhotoImage(img)
		self.canvas.delete("all")
		self.canvas.create_image(0,0,anchor=tk.NW,image=self.photo)
		return True
class OBJECT_list:
	def __init__(self,app,listbox):
		self.items=[]
		self.root=app
		self.listbox=listbox
	def conf(self):
		if self.tdata['type'] == 'box':

			new_name = self.name_widget.get()
			self.tdata["name"]=new_name

			new_x = int(self.x_widget.get())
			self.tdata["x"]=new_x

			new_y = int(self.y_widget.get())
			self.tdata["y"]=new_y

			new_size = int(self.size_widget.get())
			self.tdata["size"]=new_size

			self.items[self.tid]=self.tdata
			self.listbox.delete(self.tid)
			self.listbox.insert(self.tid,f"{self.tdata['name']} id:{self.tid}")
		self.ed.destroy()
	def edit(self,id):
		ed = tk.Toplevel(self.root,bg="#2c2c2c")
		ed.title(f"Редактор {id}")
		ed.geometry("300x400")
		self.ed=ed
		time.sleep(0.25)
		ed.grab_set()
		ed.resizable(False,False)
		data = self.items[id]
		if data['type'] == 'box':
			ed.title(f"Редактор Бокса {id}")
			name_text = tk.Label(ed,text="Display name:",bg="#2c2c2c",fg="white")
			name_text.place(x=0,y=0)
			name_widget = tk.Entry(ed,bg="#2c2c2c",fg="white")
			name_widget.place(x=90,y=0)
			name_widget.insert(0,data["name"])
			x_text = tk.Label(ed,text="X object: ",bg="#2c2c2c",fg="white")
			x_text.place(x=0,y=30)
			x_widget = tk.Entry(ed,bg="#2c2c2c",fg="white")
			x_widget.insert(0,str(data["x"]))
			x_widget.place(x=90,y=30)

			y_text = tk.Label(ed,text="Y object: ",bg="#2c2c2c",fg="white")
			y_text.place(x=0,y=60)
			y_widget = tk.Entry(ed,bg="#2c2c2c",fg="white")
			y_widget.insert(0,str(data["y"]))
			y_widget.place(x=90,y=60)

			size_text = tk.Label(ed,text="Object size: ",bg="#2c2c2c",fg="white")
			size_text.place(x=0,y=90)
			size_widget = tk.Entry(ed,bg="#2c2c2c",fg="white")
			size_widget.insert(0,str(data["size"]))
			size_widget.place(x=90,y=90)

			confirm = tk.Button(ed,text="Confirm",command=self.conf,bg="#2c2c2c",fg="white")
			confirm.place(x=150,y=300,anchor="center")
			
			self.name_widget=name_widget
			self.x_widget=x_widget
			self.size_widget=size_widget
			self.y_widget=y_widget
			self.tid = id
			self.tdata=data
			self.confirm=confirm

	def insert(self,name,data):
		id=len(self.items)
		self.listbox.insert(id,f"{name} id:{id}")
		data["name"]=name
		self.items.append(data)
def main():
	global objectsID
	app = tk.Tk()
	app.geometry("800x600")
	app.configure(bg="#2c2c2c")
	app.title("FoxEngine")
	cz=4
	pr=64
	pc=128
	ww=pc*cz
	wh=pr*cz
	cscreen = tk.Canvas(app,width=ww,height=wh)
	cscreen.place(x=400,y=150,anchor="center")
	grid=Screen(200,100,pr,pc,cz)
	screen = Widget(cscreen,grid.surface)
	objects = tk.Listbox(app,width=15,height=25,bg="#2c2c2c",fg="white")
	objects.bind("<Double-Button-1>",listbox_tap)
	objectsID=OBJECT_list(app,objects)
	objectsID.insert("Бокс",{"type":"box",'x':30,"y":30,"size":10})
	objects.place(x=0,y=0)
	running=True
	grid.render()
	screen.render()
	app.after(30,rmain,app,screen,grid,objects)
	app.mainloop()
def listbox_tap(event):
	widget = event.widget
	idx=widget.curselection()[0]
	text=widget.get(idx)
	text=text.rsplit(" ",maxsplit=1)[1][3:]
	id=int(text)
	objectsID.edit(id)
def rmain(app,screen,grid,objects):
	grid.clear()
	for item in objectsID.items:
		if item["type"] == 'box':
			for y in range(item['size']):
				for x in range(item['size']):
					grid.set_pixel(item["y"]+y,item['x']+x,1)
	screen.render()
	app.after(30,rmain,app,screen,grid,objects)
main()
