CKEDITOR.plugins.add( 'abbr', {
    icons: 'save',
    init: function( editor ) {
        // Plugin logic goes here...
    }
});

editor.addCommand( 'abbrDialog', new CKEDITOR.dialogCommand( 'abbrDialog' ) );

editor.ui.addButton( 'Abbr', {
    label: 'Insert Abbreviation',
    command: 'abbrDialog',
    toolbar: 'insert'
});