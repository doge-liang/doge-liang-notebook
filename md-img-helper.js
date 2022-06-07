const path = require('path');
const fs = require('fs');

module.exports = async function(filePath, savePath, markdownPath) {
    savePath = path.join(path.dirname(markdownPath).replace(/_posts\\article/, 'assets'), savePath);
    if (!fs.existsSync(path.dirname(savePath)))
        mkdirs(path.dirname(savePath));

    fs.copyFileSync(filePath, savePath);
    return path.relative(path.dirname(markdownPath), savePath).replace(/\\/g, '/');
    // return path.relative(markdownPath, savePath);
}

function mkdirs(dirname) {
    // console.log(dirname);
    if (fs.existsSync(dirname)) {
        return true;
    } else {
        if (mkdirs(path.dirname(dirname))) {
            fs.mkdirSync(dirname);
            return true;
        }
    }
}