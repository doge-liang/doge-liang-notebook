var MDRender = new marked.Renderer();
marked.setOptions({
    renderer: MDRender,
    gfm: true,
    tables: true,
    breaks: false,
    pedantic: false,
    sanitize: false,
    smartLists: true,
    smartypants: false
}); //基本设置
marked.setOptions({
    highlight: (code, lang) => {
        if (lang != "mermaid")
            return hljs.highlightAuto(code).value;
    }
}); //高亮设置

$(document).ready(function() {
    const http = new XMLHttpRequest();
    // const url = "../archive/Markdown/数据挖掘/数据挖掘.md";
    const url = "../archive/LaTex常用数学符号.md";
    http.open('GET', url);
    http.send();

    // $("section.markdown-body").click(function() {
    htmlobj = $.ajax({
        url: url,
        async: false
    });
    $("section.markdown-body").html(marked(http.responseText));

    // marked渲染
    $("section.markdown-body").html(marked(http.responseText));
    // mermaid渲染
    $("code.language-mermaid").each(function() {
        $(this).unwrap();
        $(this).html("<div class='mermaid'>" + $(this).text() + "</div>");
    });
    // katex渲染
    renderMathInElement(document.body, {
        delimiters: [{
            left: "$$",
            right: "$$",
            display: true
        }, {
            left: "$",
            right: "$",
            display: false
        }]
    });

});