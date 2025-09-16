const fs = require("node:fs/promises");

module.exports = {
    async onPreBuild({ netlifyConfig }) {
        // Add redirects
        const nameA = await fs.readdir("packages/pool/main");
        let tasksA = [];
        for (const a of nameA)
            tasksA.push(fs.readdir("packages/pool/main/" + a).then(nameB => {
                let tasksB = [];
                for (const pkg of nameB)
                    tasksB.push(fs.readdir("packages/pool/main/" + a + "/" + pkg).then(nameC => {
                        netlifyConfig.redirects.push({
                            from: "/packages/" + pkg + ".deb",
                            to: "/packages/pool/main/" + a + "/" + pkg + "/" + nameC[0],
                        });
                    }));
                return Promise.all(tasksB);
            }));
        await Promise.all(tasksA);
    }
};