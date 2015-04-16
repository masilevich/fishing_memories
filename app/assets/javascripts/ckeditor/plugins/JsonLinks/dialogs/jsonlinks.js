CKEDITOR.dialog.add("jsonlinksDialog", function(editor) {
	return {
		allowedContent: "a[href,target]",
		title: editor.lang.JsonLinks.lures.dialog_title,
		minWidth: 350,
		minHeight: 100,
		resizable: CKEDITOR.DIALOG_RESIZE_NONE,
		contents:[{
			id: "JsonLinks",
			label: "JsonLinks",
			elements:[{
				type: "select",
				label: editor.lang.JsonLinks.lures.select_label,
				id: "jslinks",
				items: [ ],
				onLoad : function(){
					var select = this;
        	(function($){
						$.getJSON('/lures.json', function(data){
				      $.each(data, function(){ 
				        select.add(this.title, this.url);
				      })
				    });
        	})(jQuery);
    		},
        commit: function(element) {
        	var href = this.getValue();
        	if(href) {
	          element.setAttribute("href", href);
	          var input = this.getInputElement().$;
        		element.setText(input.options[ input.selectedIndex ].text);
	        }        	
        }				
			}]
		}],
		onOk: function() {
			var dialog = this;
			
			element = editor.document.createElement( 'a' );
			element.setAttribute("target","_blank");

			this.insertMode = true;
			this.element = element;
			
			this.commitContent(this.element);

			if(this.insertMode) {
				editor.insertElement(this.element);
			}
		}
	};
});
