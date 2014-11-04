<?php
    session_start();
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
		"http://www.w3.org/TR/html4/loose.dtd">
<head>
<style type="text/css">
body {font-family: arial;}
	.tab {
		margin-left:    1cm;
	}
	.clock {
		float:          left;
		margin-right:   0.25cm;
	}
</style>
</head>
<?php
	require_once 'constants.php';

	$user     = filter_input(INPUT_POST, "user",     FILTER_SANITIZE_STRING);
	$project  = filter_input(INPUT_POST, "project",  FILTER_SANITIZE_STRING);
	$key      = filter_input(INPUT_POST, "key",      FILTER_SANITIZE_STRING);
	$status   = filter_input(INPUT_POST, "status",   FILTER_SANITIZE_STRING);

// print_r($key);
//	$user    = "darren";
//	$project = "";
//	$key     = "";
//	$status  = "";

	// increment clock animation...
	$status   = ($status + 1) % 12;
	if ($status == 0) {          $clock = "<img src=\"../images/12.png\" alt-text=\"12\" class=\"clock\" >";
	} else if ($status == 1) {   $clock = "<img src=\"../images/01.png\" alt-text=\"01\" class=\"clock\" >";
	} else if ($status == 2) {   $clock = "<img src=\"../images/02.png\" alt-text=\"02\" class=\"clock\" >";
	} else if ($status == 3) {   $clock = "<img src=\"../images/03.png\" alt-text=\"03\" class=\"clock\" >";
	} else if ($status == 4) {   $clock = "<img src=\"../images/04.png\" alt-text=\"04\" class=\"clock\" >";
	} else if ($status == 5) {   $clock = "<img src=\"../images/05.png\" alt-text=\"05\" class=\"clock\" >";
	} else if ($status == 6) {   $clock = "<img src=\"../images/06.png\" alt-text=\"06\" class=\"clock\" >";
	} else if ($status == 7) {   $clock = "<img src=\"../images/07.png\" alt-text=\"07\" class=\"clock\" >";
	} else if ($status == 8) {   $clock = "<img src=\"../images/08.png\" alt-text=\"08\" class=\"clock\" >";
	} else if ($status == 9) {   $clock = "<img src=\"../images/09.png\" alt-text=\"09\" class=\"clock\" >";
	} else if ($status == 10) {  $clock = "<img src=\"../images/10.png\" alt-text=\"10\" class=\"clock\" >";
	} else if ($status == 11) {  $clock = "<img src=\"../images/11.png\" alt-text=\"11\" class=\"clock\" >";
	} else {                     $clock = "[ * ]";
	}

	$dirFigureBase = $directory."users/".$user."/projects/".$project."/";
	$urlFigureBase = $url."users/".$user."/projects/".$project."/";

	// Load 'dataType' from project folder.
	$handle   = fopen($dirFigureBase."dataType.txt", "r");
	$dataType = trim(fgets($handle));
	fclose($handle);

	// Load 'parent' from project folder.
	$handle = fopen($dirFigureBase."parent.txt", "r");
	$parent = trim(fgets($handle));
	fclose($handle);

	echo "\n<!--\tuser    = ".$user;
	echo "\n\tproject = ".$project." --!>";

	if (file_exists($dirFigureBase."complete.txt")) {
		echo "\n<!-- complete file found.\n--!>";
		// Hide iframe and adjust color of entry to indicate completion.
		?>
		<html>
		<body onload = "parent.update_project_label_color('<?php echo $key; ?>','#00AA00'); parent.update_project_remove_iframe('<?php echo $key; ?>');">
		</body>
		</html>
		<?php
	} else if (file_exists($dirFigureBase."error.txt")) {
		echo "\n<!-- error file found.\n--!>";
		// Load error.txt from project folder.
        $handle = fopen($dirFigureBase."error.txt", "r");
        $error = fgets($handle);
        fclose($handle);
		?>
		<html>
		<body onload = "parent.resize_iframe('<?php echo $key; ?>', 115);" >
			<font color="red"><b>[Error : Consult site admin.]</b></font><br>
			<?php echo $error; ?>
		</body>
		</html>
		<?php
	} else if (file_exists($dirFigureBase."working.txt")) {
		echo "\n<!-- working file found. --!>\n";
		// Load last line from "condensed_log.txt" file.
		$condensedLog      = explode("\n", trim(file_get_contents($dirFigureBase."condensed_log.txt")));
		$condensedLogEntry = $condensedLog[count($condensedLog)-1];
		?>
		<script type="text/javascript">
		var user    = "<?php echo $user; ?>";
		var project = "<?php echo $project; ?>";
		var key     = "<?php echo $key; ?>";
		var status  = "<?php echo $status; ?>";
		reload_page=function() {
			// Make a form to generate a form to POST information to pass along to page reloads, auto-triggered by form submit.
			var autoSubmitForm = document.createElement('form');
			    autoSubmitForm.setAttribute('method','post');
			    autoSubmitForm.setAttribute('action','project.working_server.2.php');
			var input2 = document.createElement('input');
			    input2.setAttribute('type','hidden');
			    input2.setAttribute('name','key');
			    input2.setAttribute('value',key);
			    autoSubmitForm.appendChild(input2);
			var input2 = document.createElement('input');
			    input2.setAttribute('type','hidden');
			    input2.setAttribute('name','user');
			    input2.setAttribute('value',user);
			    autoSubmitForm.appendChild(input2);
			var input3 = document.createElement('input');
			    input3.setAttribute('type','hidden');
			    input3.setAttribute('name','project');
			    input3.setAttribute('value',project);
			    autoSubmitForm.appendChild(input3);
			var input4 = document.createElement('input');
			    input4.setAttribute('type','hidden');
			    input4.setAttribute('name','status');
			    input4.setAttribute('value',status);
			    autoSubmitForm.appendChild(input4);
			autoSubmitForm.submit();
		}
		// Initiate recurrent call to reload_page function, which depends upon project status.
		var internalIntervalID = window.setInterval(reload_page, 3000);
		</script>
		<html>
		<body onload = "parent.resize_iframe('<?php echo $key; ?>', 20*2+12); parent.update_project_label_color('<?php echo $key; ?>','#BB9900');" class="tab">
		<font color="red"><b>[Processing uploaded data.]</b></font>
		<?php
		echo $clock."<br>";
		if (strcmp($dataType,"0") == 0) {
			echo "SnpCgh microarray analysis usually complete in a few minutes.";
		} else {
			echo $condensedLogEntry;
		}
	} else {
		echo "\n<html>\n<body>\n";
	//	echo "dirBase = ".$dirFigureBase."<br>\n";
	//	echo "urlBase = ".$urlFigureBase."<br>\n";
		echo "complete.txt file not found properly.<br>\n";
	}
	echo "\n";
	?>
	</body>
	<script type="text/javascript">
		function loadImage(imageUrl,imageScale,iframeHeight) {
			document.getElementById('imageContainer').innerHTML = "<img src=\""+imageUrl+"\" style=\"max-width:"+imageScale+"%\"></img>";
			parent.resize_iframe('<?php echo $key; ?>', iframeHeight);
		}
		function loadExternal(imageUrl) {
			window.open(imageUrl);
		}
	</script>
</HTML>
