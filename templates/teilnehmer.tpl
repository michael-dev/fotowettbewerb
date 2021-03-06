{if $projekt.logo_data}
<img align="right" src="data:{$projekt.logo_mimetype|escape};base64,{base64_encode($projekt.logo_data)}">
{/if}

<h1>{$projekt.name|escape}</h1>

{if $needtos}

<form action="index.php" method="POST">
<input type="hidden" name="action" value="tos">
<input type="hidden" name="uuid" value="{$uuid|escape}">
<input type="hidden" name="csrf" value="{$csrf|escape}">
<input type="hidden" name="tos" value="{md5($projekt.tos)}">
<fieldset><legend>Nutzungsbedingungen</legend>
<div class="prebox">
{$projekt.tos|escape}
</div>
</fieldset>
<fieldset>
 <legend>Persönliche Informationen</legend>
 <label for="name">Vollständiger Name:</label> <input type="text" value="{$regname|escape}" name="name" placeholder="Vorname Nachname"/>
</fieldset>
<input type="submit" value="Zustimmen und Absenden">
</form>

{else}

{* Slots anzeigen *}
{* freier Slot: Upload; belegter Slot: Download + Entfernen + Name ändern*}

<h2>Eingereichte Bilder</h2>

{assign var="uploadshown" value=false}
<ol>
{for $i = 1 to $projekt.numSlot}
<li>
 {if isset($data[$i])}
<form action="index.php" method="POST" enctype="multipart/form-data" style="display: inline-block;">
 <input type="hidden" name="action" value="renameslot">
 <input type="hidden" name="slotIdx" value="{$i}">
 <input type="hidden" name="uuid" value="{$uuid|escape}">
 <input type="hidden" name="csrf" value="{$csrf|escape}">
<label for="name">Name:</label> <input type="text" name="name" value="{$data[$i].name|escape}">
<input type="submit" value="Bild umbennen">
</form>
<form action="index.php" method="POST" enctype="multipart/form-data" style="display: inline-block;">
 <input type="hidden" name="action" value="delslot">
 <input type="hidden" name="slotIdx" value="{$i}">
 <input type="hidden" name="uuid" value="{$uuid|escape}">
 <input type="hidden" name="csrf" value="{$csrf|escape}">
<input type="submit" value="Bild löschen">
</form>
<form action="index.php" method="POST" enctype="multipart/form-data" style="display: inline-block;">
 <input type="hidden" name="action" value="download">
 <input type="hidden" name="slotIdx" value="{$i}">
 <input type="hidden" name="uuid" value="{$uuid|escape}">
 <input type="hidden" name="csrf" value="{$csrf|escape}">
<input type="submit" value="Bild herunterladen">
</form>
 {else}
  {if !$uploadshown}
   {assign var="uploadshown" value=true}
<form action="index.php" method="POST" enctype="multipart/form-data" id="addslot{$i}">
 <input type="hidden" name="action" value="addslot">
 <input type="hidden" name="slotIdx" value="{$i}">
 <input type="hidden" name="uuid" value="{$uuid|escape}">
 <input type="hidden" name="csrf" value="{$csrf|escape}">
<label for="name">Name:</label> <input type="text" name="name" value="">
<label for="bild">Bild:</label> <input name="bild" type="file" size="50" accept="image/png,image/jpeg,image/gif,*.png,*.jpeg,*.jpg,*.gif">
<input type="submit" value="Bild hochladen">
</form>

<p>Es können nur Dateien vom Typ "image/png", "image/jpeg" und "image/gif" hochgeladen werden, die höchstens {$upload_max_filesize|escape} Bytes groß sind.</p>

<div id="progress{$i}" class="progress" style="display: none;"><div id="bar{$i}" class="bar"></div><div id="percent{$i}" class="percent">0%</div></div>
<div id="status{$i}" style="display: none; white-space: pre-wrap;"></div>

<script type="text/javascript">
$(function() {ldelim}
  var progress = $('#progress{$i}');
  var bar = $('#bar{$i}');
  var percent = $('#percent{$i}');
  var status = $('#status{$i}');

  var options = {ldelim}
    beforeSend: function() {ldelim}
        status.css('display','');
        progress.css('display','');
        var percentVal = '0%';
        bar.width(percentVal)
        percent.html(percentVal);
    {rdelim},
    uploadProgress: function(event, position, total, percentComplete) {ldelim}
        var percentVal = percentComplete + '%';
        bar.width(percentVal)
        percent.html(percentVal);
    {rdelim},
    success: function() {ldelim}
        var percentVal = '100%';
        bar.width(percentVal)
        percent.html(percentVal);
        status.css('display','none');
        self.location.reload();
    {rdelim},
	  complete: function(xhr) {ldelim}
		    status.text(xhr.responseText);
        status.css('background-color','red');
  	{rdelim}
  {rdelim};
  $('#addslot{$i}').ajaxForm(options);
{rdelim});
</script>

  {else}
   <i>frei</i>
  {/if}
 {/if}
</li>
{/for}
</ol>

<h2>Nutzungsbedingungen</h2>
<div>
Hallo {$regname|escape},<br/>
<br/>
du hast bereits folgenden Nutzungsbedingungen zugestimmt:
</div>

<div class="prebox">
{$projekt.tos|escape}
</div>

{/if}
