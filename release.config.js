module.exports = {
    "dryRun": false,
    "plugins": [
        "@semantic-release/commit-analyzer",
        "@semantic-release/release-notes-generator",
        [
            "@semantic-release/changelog",
            {
                "changelogFile": "docs/CHANGELOG.md"
            }
        ],
        "@semantic-release/github",
        [
            "@semantic-release/git",
            {
                "assets": [
                    "docs/CHANGELOG.md",
                    "thesis.pdf"
                ],
                "message": "chore(release): ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}"
            }
        ]
    ]
};
