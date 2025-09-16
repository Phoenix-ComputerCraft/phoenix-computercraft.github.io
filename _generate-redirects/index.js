const fs = require("node:fs/promises");

module.exports = {
    onPreBuild({ netlifyConfig }) {
        // Add redirects
        fs.readdir("packages/pool/main").then(nameA => {
            for (const a of nameA)
                fs.readdir("packages/pool/main/" + a).then(nameB => {
                    for (const pkg of nameB)
                        fs.readdir("packages/pool/main/" + a + "/" + pkg).then(nameC => {
                            netlifyConfig.redirects.push({
                                from: "/packages/" + pkg + ".deb",
                                to: "/packages/pool/main/" + a + "/" + pkg + "/" + nameC[0],
                            });
                        });
                });
        });
    }
};