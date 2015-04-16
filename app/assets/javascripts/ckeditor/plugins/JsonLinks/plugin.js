CKEDITOR.plugins.add( 'JsonLinks', {
  icons: 'jsonlinks',
  init: function( editor ) {
    editor.addCommand( 'jsonlinks', new CKEDITOR.dialogCommand( 'jsonlinksDialog' ) );
    editor.ui.addButton( 'JsonLinks', {
      label: 'Добавить приманку',
      icons: 'jsonlinks',
      command: 'jsonlinks'
    });

    //CKEDITOR.dialog.add( 'jsonlinksDialog', this.path + 'dialogs/jsonlinks.js' );
  }
});