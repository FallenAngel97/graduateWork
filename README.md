# Backup_system
Welcome to my project. This is the graduate work for my bachelor degree.
The installation process is very simple:
- You need the Vagrant & Virtualbox.
- Go to the folders & type: `vagrant up`. This will download the boxes. There can be a warning from your local firewall about the Virtualbox network. This is normal, because this works in the sandbox by default, visible in the 192.168.50.1/24 network.
- (Optional) Then, launch the debugging application by command `gulp` within that directory

Navigate to Master folder to see it in action. Type in the `192.168.50.4` or `localhost:3000` if you have launched vagrant. You will be redirected to the slave server. To watch the status - write `192.168.50.4/index` or `localhost:3000/index`.
It best works with sourcemaps enabled in your preferred browser.

As the database server is separated from other for the maintainability, 
the correct order to open up the connections is:

**DB -> Res1 -> Res2 -> Master**

Please, take a note, that for the proper stylesheet and scripts resources, HTTP cahce should be turned off. This can be done in firefox by pressing `F12` and then -> gear icon. 

Please, pay attention to that fact, that it is WIP, I am not responsible for any bugs, that you may encounter. For this you can open up an issue here, on github. Also, I do not own the rights to any library/OS/framework/etc here, as they are distributed on their own licenses. For future information you should visit their websites to find out terms of use.

**IMPORTANT**
If you upgraded Vagrant(at least, this is reproducible on Windows), please be sure to re-create the virtual machines. There is some bug, which prevents SSH to function properly after updating.

That's it. Thanks for attention ^.^