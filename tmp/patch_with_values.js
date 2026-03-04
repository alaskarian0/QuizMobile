const fs = require('fs');
const path = require('path');

function replaceInDir(dir) {
    const files = fs.readdirSync(dir);
    for (const file of files) {
        const fullPath = path.join(dir, file);
        if (fs.statSync(fullPath).isDirectory()) {
            replaceInDir(fullPath);
        } else if (file.endsWith('.dart')) {
            let content = fs.readFileSync(fullPath, 'utf8');
            if (content.includes('withValues')) {
                console.log('Patching ' + fullPath);
                // Replace withValues(alpha: X) with withOpacity(X)
                content = content.replace(/withValues\(alpha:\s*([^)]+)\)/g, 'withOpacity($1)');
                fs.writeFileSync(fullPath, content);
            }
        }
    }
}

replaceInDir('c:/Users/ASK 1/Documents/yousef/quize/QuizeMobile/lib');
