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

function list(data) {
    console.log(data);
}


$(document).ready(function() {
    const url = "https://raw.githubusercontent.com/doge-liang/doge-liang-notebook/master/archive/LaTex常用数学符号.md";

    function GetJsonp() {
        var tag = document.createElement('script');
        tag.src = url;
        document.head.appendChild(tag);
        document.head.removeChild(tag);
    }

    htmlobj = $.ajax({
        url: url,
        type: 'GET',
        dataType: 'jsonp',
        jsonpCallback: 'list'
    });

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