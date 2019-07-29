hexo.extend.generator.register('test', function (locals) {

    // Array
    return [
        { path: 'foo.html', data: 'foo', layout: 'foo' },
        { path: 'bar.html', data: 'bar' }
    ];
});


hexo.extend.console.register('config', 'Display configuration', function (args) {
    console.log("hexo.config");
});