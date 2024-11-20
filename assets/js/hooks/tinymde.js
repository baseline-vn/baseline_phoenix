// import TinyMDE from "tiny-markdown-editor";
const TinyMDE = require('tiny-markdown-editor');


const MarkdownEditor = {
    mounted() {
        const textarea = this.el.querySelector("textarea");
        const toolbar = document.getElementById("toolbar");

        if (!textarea || !toolbar) {
            console.error("Textarea or toolbar element not found");
            return;
        }

        this.tinyMDE = new TinyMDE.Editor({
            textarea: textarea,
        });

        this.commandBar = new TinyMDE.CommandBar({
            element: toolbar,
            editor: this.tinyMDE,
        });
        textarea.addEventListener("input", () => {
            this.pushEvent("update_markdown", { markdown: textarea.value });
            console.log(textarea.value);
        });

    },

    update() {
        this.tinyMDE?.destroy();
        this.commandBar?.destroy();
    }
}
export default MarkdownEditor;