from tkinter import *
from tkinter import filedialog,simpledialog,messagebox
import tkinter.scrolledtext as scrolledtext 
import tkinter.font
from tkinter.filedialog import askopenfilename, asksaveasfilename 
from datetime import datetime
import win32api
import os
root = Tk()
root.iconbitmap(r'C:\Users\vikra\OneDrive\Documents\Demo\sample.ico')
root.configure(background='yellow')
root.title("Text Editor ") 
root.geometry("918x450")
TextArea= scrolledtext.ScrolledText (root, height = 12) 
TextArea.pack (expand=True, fill=BOTH) 
Desired_font = tkinter.font.Font( family = "Comic Sans MS", size = 16)
TextArea.configure(font=Desired_font)
file = None 
MenuBar = Menu(root)
FileMenu = Menu(MenuBar, tearoff=0) 
EditMenu = Menu (MenuBar , tearoff=0)
HelpMenu = Menu (MenuBar , tearoff=0)
MenuBar.add_cascade (label="File", menu=FileMenu)
MenuBar.add_cascade(label="Edit",menu=EditMenu) 
MenuBar.add_cascade(label="Help",menu=HelpMenu) 


root.config(menu=MenuBar) 

def newFile():
    global file
    root.title("Untitled Notepad")
    TextArea.delete (1.0, END)

def openFile(): 
    global file
    file = askopenfilename(defaultextension =".txt", filetypes=[("Text Documents", "*.txt")])
    if file == "":
         file = None

    else:
        root.title(os.path.basename(file) +"- Notepad")
        f=open(file,"r")
        TextArea.insert(1.0, f.read())
        f.close()

def saveFile(): 
    global file
    if file == None:
        file = asksaveasfilename(defaultextension=", txt", filetypes=[("ALL Files","."),("Text Documents","txt")]) 
        if file == "":
           file = None
        else:
            f = open(file, "w") 
            f.write(TextArea.get(1.0, END))
            f.close()
            root.title(os.path.basename(file)+" Notepad ")
    else:
        f = open(file, "w")
        f.write(TextArea.get(1.0, END)) 
        f.close()

def print_file():
    
    file_to_print = filedialog.askopenfilename(initialdir="/", title="Select file", filetypes=(("Text files", "*.txt"), ("all files", "*.*")))
    if file_to_print:
        win32api.ShellExecute(0, "print", file_to_print, None, ".", 0)
  
def exitFile():
    root.destroy()

def cmdFind():    
    TextArea.tag_remove("Found",'1.0', END)
    find = simpledialog.askstring("Find", "Find what:")
    if find:
        idx = '1.0'    
    while 1:
        idx = TextArea.search(find, idx, nocase = 1, stopindex = END)
        if not idx:
            break
        lastidx = '%s+%dc' %(idx, len(find))
        TextArea.tag_add('Found', idx, lastidx)
        idx = lastidx
    TextArea.tag_config('Found', foreground = 'white', background = 'orange')
    TextArea.bind("<1>", click)

def click(event):   
    TextArea.tag_config('Found',background='white',foreground='black')

def cut():
    TextArea.event_generate(("<<Cut>>" )) 
def copy():
    TextArea.event_generate(("<<Copy>>")) 
def paste():
    TextArea.event_generate(("<<Paste>>")) 

def clear():
    TextArea.event_generate(("<<Clear>>")) 
def select():     #
    TextArea.event_generate("<<SelectAll>>")
def time1():    
    now = datetime.now()
    dtString = now.strftime("%d/%m/%Y %H:%M:%S")
    label = messagebox.showinfo("Time and Date", dtString)

def about():
    label = messagebox.showinfo("About","Notepad by _VIKRAM_  version 1.1\n    Developed on Python Tkinter")

def onclosing():
    if messagebox.askyesnocancel("Notepad !! ","Do you Want to save Changes and Quit"):
        saveFile()
        root.destroy()
    else:
        root.destroy()

FileMenu.add_command(label="New" , command=newFile)
FileMenu.add_command (label="Open" , command = openFile) 
FileMenu.add_command(label="Save", command = saveFile)
FileMenu.add_command(label="Print", command = print_file)
FileMenu.add_separator()
FileMenu.add_command(label = "Exit" , command = exitFile)
EditMenu.add_command(label = "Cut", command = cut) 
EditMenu.add_command(label="Copy", command = copy)
EditMenu.add_command(label = "Paste", command = paste)
EditMenu.add_separator()
EditMenu.add_command(label = "SelectAll", command = select)
EditMenu.add_command(label = "Delete", command = clear)
HelpMenu.add_command(label="Find", command = cmdFind)
HelpMenu.add_command(label = "About", command = about)
HelpMenu.add_command(label = "Time", command = time1)
root.protocol("WM_DELETE_WINDOW",onclosing)

root.mainloop()

