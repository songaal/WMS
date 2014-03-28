<%@ page contentType="text/html; charset=UTF-8"%>
 
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>jQuery UI Datepicker - Display inline</title>
    

    <link rel="stylesheet" href="http://code.jquery.com/ui/1.9.1/themes/base/jquery-ui.css" />
	<style>

		/* The following styles are just to make the page look nice. */

		/* Workaround to show Arial Black in Firefox. */
		@font-face
		{
			font-family: 'arial-black';
			src: local('Arial Black');
		}

		*[contenteditable="true"]
		{
			padding: 10px;
		}

		#container
		{
			width: 960px;
			margin: 30px auto 0;
		}

		#header
		{
			overflow: hidden;
			padding: 0 0 30px;
			border-bottom: 5px solid #05B2D2;
			position: relative;
		}

		#headerLeft,
		#headerRight
		{
			width: 49%;
			overflow: hidden;
		}

		#headerLeft
		{
			float: left;
			padding: 10px 1px 1px;
		}

		#headerLeft h2,
		#headerLeft h3
		{
			text-align: right;
			margin: 0;
			overflow: hidden;
			font-weight: normal;
		}

		#headerLeft h2
		{
			font-family: "Arial Black",arial-black;
			font-size: 4.6em;
			line-height: 1.1em;
			text-transform: uppercase;
		}

		#headerLeft h3
		{
			font-size: 2.3em;
			line-height: 1.1em;
			margin: .2em 0 0;
			color: #666;
		}

		#headerRight
		{
			float: right;
			padding: 1px;
		}

		#headerRight p
		{
			line-height: 1.8em;
			text-align: justify;
			margin: 0;
		}

		#headerRight p + p
		{
			margin-top: 20px;
		}

		#headerRight > div
		{
			padding: 20px;
			margin: 0 0 0 30px;
			font-size: 1.4em;
			color: #666;
		}

		#columns
		{
			color: #333;
			overflow: hidden;
			padding: 20px 0;
		}

		#columns > div
		{
			float: left;
			width: 33.3%;
		}

		#columns #column1 > div
		{
			margin-left: 1px;
		}

		#columns #column3 > div
		{
			margin-right: 1px;
		}

		#columns > div > div
		{
			margin: 0px 10px;
			padding: 10px 20px;
		}

		#columns blockquote
		{
			margin-left: 15px;
		}

		#tagLine
		{
			border-top: 5px solid #05B2D2;
			padding-top: 20px;
		}

		#taglist {
			display: inline-block;
			margin-left: 20px;
			font-weight: bold;
			margin: 0 0 0 20px;
		}
		
		
body { counter-reset: section ; }

h2 { 
	counter-increment: section; 
	counter-reset: section2 ;
}

h2:before{ 
    content: counter(section)"장. "

}

h3 { counter-increment: section2; }
h3:before{ 
    content: counter(section)"."counter(section2)". "

}

	</style>

<link href="/WMS/assets/fullcalendar/fullcalendar.css" rel="stylesheet">


    <script src="http://code.jquery.com/jquery-1.8.2.js"></script>
    <script src="http://code.jquery.com/ui/1.9.1/jquery-ui.js"></script>
    

<script src="http://code.jquery.com/ui/1.9.1/jquery-ui.js"></script>
<script src="/WMS/assets/js/bootstrap.js"></script>
<script src="/WMS/assets/js/bootstrap-datepicker.js"></script>
<script src="/WMS/assets/js/wms.js"></script>
<script src="/WMS/assets/ckeditor2/ckeditor.js"></script>
<script>

// This code is generally not necessary, but it is here to demonstrate
// how to customize specific editor instances on the fly. This fits well
// this demo because we have editable elements (like headers) that
// require less features.

// The "instanceCreated" event is fired for every editor instance created.
CKEDITOR.on( 'instanceCreated', function( event ) {
	var editor = event.editor,
		element = editor.element;

	// Customize editors for headers and tag list.
	// These editors don't need features like smileys, templates, iframes etc.
	//if ( element.is( 'h1', 'h2', 'h3' ) || element.getAttribute( 'id' ) == 'taglist' ) {
		// Customize the editor configurations on "configLoaded" event,
		// which is fired after the configuration file loading and
		// execution. This makes it possible to change the
		// configurations before the editor initialization takes place.
		editor.on( 'configLoaded', function() {

			// Remove unnecessary plugins to make the editor simpler.
			editor.config.removePlugins = 'colorbutton,find,flash,font,' +
				'forms,iframe,image,newpage,removeformat,' +
				'smiley,specialchar,stylescombo,templates';

			// Rearrange the layout of the toolbar.
			editor.config.toolbarGroups = [
				{ name: 'editing',		groups: [ 'basicstyles', 'links' ] },
				{ name: 'undo' },
				{ name: 'clipboard',	groups: [ 'selection', 'clipboard' ] },
				{ name: 'about' }
			];
		});
	//}
});

</script>
<script>
 $(function() {
     $( "#datepicker11" ).datepicker();
 
  /* CKEDITOR.replace('myTextarea', {
width : '100%',
height : 400,
});

CKEDITOR.instances.myTextarea.on('key', function(event) {
      //Text change code
if(event.data.keyCode == 1114195){
	console.log("Save >>", event.editor);
	event.cancel();
}
  }); */
 });

 </script>
 
 <style>
 .cke_editable9 {border:1px solid #eee; }
 
 </style>
 
</head>
<body>
<div class="span12">
		<table class="fc-border-separate" style="width: 100%" cellspacing="0">
			<thead>
				<tr class="fc-first">
					<th class="fc-mon fc-widget-header fc-first" style="width: 123px;">날짜</th>
					<th class="fc-mon fc-widget-header" style="width: 123px;">2/4</th>
					<th class="fc-tue fc-widget-header" style="width: 123px;">2/5</th>
					<th class="fc-wed fc-widget-header" style="width: 123px;">2/6</th>
					<th class="fc-thu fc-widget-header" style="width: 123px;">2/7</th>
					<th class="fc-fri fc-widget-header fc-last" style="width: 123px;">2/8</th>
				</tr>
				<tr class="fc-last">
					<th class="fc-mon fc-widget-header fc-first" style="width: 123px;">요일</th>
					<th class="fc-mon fc-widget-header" style="width: 123px;">월</th>
					<th class="fc-tue fc-widget-header" style="width: 123px;">화</th>
					<th class="fc-wed fc-widget-header" style="width: 123px;">수</th>
					<th class="fc-thu fc-widget-header" style="width: 123px;">목</th>
					<th class="fc-fri fc-widget-header fc-last" style="width: 123px;">금</th>
				</tr>
			</thead>
			<tbody>
				<tr class="fc-week0 fc-first fc-last">
					<th class="fc-widget-content fc-day0" style="width: 123px;">다나와 APL2</th>
					<td class="fc-mon fc-widget-content fc-day1" style="width: 123px;" contenteditable="true">
								소녀시대 유리의 복근이 눈길을 끌었다.2
					</td>
					<td class="fc-tue fc-widget-content fc-day2" style="width: 123px;" contenteditable="true"></td>
					<td class="fc-wed fc-widget-content fc-day3" style="width: 123px;" contenteditable="true"></td>
					<td class="fc-thu fc-widget-content fc-day4" style="width: 123px;" contenteditable="true"></td>
					<td class="fc-fri fc-widget-content fc-day5 fc-last" style="width: 123px;" contenteditable="true"></td>
				</tr>
				
				
			</tbody>
		</table>
	</div>
<div id="header">
		<div id="headerLeft">
			<div><h2 id="" contenteditable="true">
				패스트캣 활용``
			</h2></div>
			
			<div><h3 id="" contenteditable="true">
				sub패스트캣 활용5551
			</h3></div>
			
			<div><h3 id="" contenteditable="true">
				sub패스트캣 활용2555
			</h3></div>
			
			
			<div><h2 id="" contenteditable="true">
				패스트캣 정의
			</h2></div>
			
			<div><h3 id="" contenteditable="true">
				sub패스트캣 활용1
			</h3></div>
			
			<div><h3 id=""  contenteditable="true">
				sub패스트캣 활용223r11
			</h3></div>
			
			
	</div>
</div>
<h3 contenteditable="true">소녀시대 유리의 복근이 눈길을 끌었다.</h3>
<div id="myTextarea" contenteditable="true">
소녀시대 유리의 복근이 눈길을 끌었다. 
최근 한 온라인 커뮤니티 게시판에는 소녀시대 유리의 복근이 담긴 사진이 게재돼 폭발적인 관심을 불러 모았다. 
유리의 복근 사진은 지난 5일 방송된 MBC ‘쇼! 음악중심’에서의 소녀시대 컴백 무대의 한 장면을 캡처한 것으로 해당 사진 속 유리는 허리를 드러낸 짧은 상의를 입은 채 웨이브를 추고 있다. 
</div>
</body>
</html>