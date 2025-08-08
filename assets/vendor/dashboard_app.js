/**
this file contains startup behaviour for the dashboard not the portal
 **/


var main = {
    /**this function is run when the app root.html.heex file loads**/
    init:function(){
	//for right menu items
	const btn = document.getElementById('menu-btn')
	const menu = document.getElementById('menu')

	//Click handler for right hand menus
	btn.addEventListener('click',function(e){
	    btn.classList.toggle('open')
	    menu.classList.toggle('flex')
	    menu.classList.toggle('hidden')
	});
	
    }
}

document.addEventListener("DOMContentLoaded", function(event) { 
    main.init()
});

