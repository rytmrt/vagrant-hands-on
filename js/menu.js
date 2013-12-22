$(function () {
var menu = "
    <div class='navbar navbar-default navbar-fixed-top' role='navigation'>
      <div class='container'>
        <div class='navbar-header'>
          <button type='button' class='navbar-toggle' data-toggle='collapse' data-target='.navbar-collapse'>
            <span class='sr-only'>Toggle navigation</span>
            <span class='icon-bar'></span>
            <span class='icon-bar'></span>
            <span class='icon-bar'></span>
          </button>
          <a class='navbar-brand' href='https://github.com/rytmrt/'>rytmrt</a>
        </div>
        <div class='navbar-collapse collapse'>
          <ul class='nav navbar-nav'>
            <li class='active'><a href='#'>Home</a></li>
            <li><a href='https://github.com/rytmrt/vagrant-hands-on'>Github Project</a></li>
            <li><a href='./downloads.html'>Downloads</a></li>
          </ul>
        </div>
      </div>
    </div>

  $("#menubar").prepend(menu);
});
