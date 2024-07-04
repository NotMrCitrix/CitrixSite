import tkinter as tk
from tkinter import messagebox
import requests
import os
import ctypes
import sys

def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False

def fetch_and_update_hosts_file():
    url = "https://a.dove.isdumb.one/list.txt"
    file_path = r"C:\Windows\System32\drivers\etc\hosts"

    try:
        response = requests.get(url)
        response.raise_for_status()
        new_content = response.text.strip()

        # Read the existing content from the hosts file
        if os.path.exists(file_path):
            with open(file_path, 'r') as file:
                existing_content = file.read().strip()
        else:
            existing_content = ""

        # Split existing and new content into lines
        existing_lines = set(existing_content.splitlines())
        new_lines = set(new_content.splitlines())

        # Combine the content without duplicating lines
        combined_lines = existing_lines.union(new_lines)
        combined_content = "\n".join(combined_lines)

        # Write the combined content back to the hosts file
        with open(file_path, 'w') as file:
            file.write(combined_content)

        messagebox.showinfo("Success", f"Hosts file updated successfully at {file_path}")
    except Exception as e:
        messagebox.showerror("Error", f"An error occurred: {e}")

def start_process():
    fetch_and_update_hosts_file()

def create_ui():
    root = tk.Tk()
    root.title("GenDoveCatcher by Mr. Citrix")
    root.geometry("600x400")

    # Create a canvas to draw the background
    canvas = tk.Canvas(root, width=600, height=400)
    canvas.pack(fill="both", expand=True)

    # Create rainbow background
    rainbow_colors = ['red', 'orange', 'yellow', 'green', 'blue', 'indigo', 'violet']
    for i, color in enumerate(rainbow_colors):
        canvas.create_rectangle(0, i * 400 // len(rainbow_colors), 600, (i + 1) * 400 // len(rainbow_colors), fill=color, outline=color)

    # Add the start button
    start_button = tk.Button(root, text="Start", command=start_process, font=("Helvetica", 16), width=10, height=2)
    start_button_window = canvas.create_window(300, 200, window=start_button)

    root.mainloop()

if __name__ == "__main__":
    if is_admin():
        create_ui()
    else:
        # Relaunch the script with admin rights
        ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, __file__, None, 1)
