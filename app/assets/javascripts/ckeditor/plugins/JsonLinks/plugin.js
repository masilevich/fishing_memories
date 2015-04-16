CKEDITOR.plugins.add( 'JsonLinks', {
  icons: 'jsonlinks',
  lang: [ 'ru' ],
  init: function( editor ) {
    editor.addCommand( 'jsonlinks', new CKEDITOR.dialogCommand( 'jsonlinksDialog' ) );
    editor.ui.addButton( 'JsonLinks', {
      label: editor.lang.JsonLinks.lures.button_label,
      icons: 'jsonlinks',
      command: 'jsonlinks'
    });

    //CKEDITOR.dialog.add( 'jsonlinksDialog', this.path + 'dialogs/jsonlinks.js' );
  }
});