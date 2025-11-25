'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"favicon-16x16.png": "1ad6a3fcd47cba3aa1ba0ed0110ad11b",
"flutter_bootstrap.js": "40ed7337d155e73f0ba6776f3220404b",
"version.json": "26da6f549d9f71d454acb87c68badcc2",
"favicon.ico": "8abcf3fb67bc3c44156352eda6ed8a73",
"index.html": "8877e28bd17148d2895f93380b430ba4",
"/": "8877e28bd17148d2895f93380b430ba4",
"bookmarklet.html": "1a1086e70092d50689f7a4fa079e8735",
"bookmarklet/dist/bookmarklet.js": "e8481bdb2f64d8c3442781fee295a802",
"bookmarklet/node_modules/.bin/acorn": "ec5fa9e6e8029bf6611634c978dd6e22",
"bookmarklet/node_modules/.bin/terser": "b54eba26d62579504aac2f781212fd4e",
"bookmarklet/node_modules/commander/LICENSE": "25851d4d10d6611a12d5571dab945a00",
"bookmarklet/node_modules/commander/CHANGELOG.md": "e1c5db594f4715b2739f5a4dd4847a7e",
"bookmarklet/node_modules/commander/typings/index.d.ts": "4c4511acf813867dd86c5df436f54f69",
"bookmarklet/node_modules/commander/index.js": "5d56ccd99113d3a04f449b728b07c4c4",
"bookmarklet/node_modules/commander/Readme.md": "1f9fca16c7cab4f43d4a9d582f76aac6",
"bookmarklet/node_modules/commander/package.json": "b654c566fc6c38e6f17dd3a0f7d8ad33",
"bookmarklet/node_modules/acorn/LICENSE": "6e381572c3ee395547475a1464db5060",
"bookmarklet/node_modules/acorn/bin/acorn": "ec5fa9e6e8029bf6611634c978dd6e22",
"bookmarklet/node_modules/acorn/CHANGELOG.md": "117bcd4c4a0f180a1ad917f7be738170",
"bookmarklet/node_modules/acorn/dist/bin.js": "ac5d61632c102cf185305ec79c619aa6",
"bookmarklet/node_modules/acorn/dist/acorn.mjs": "a298e7f79829f41494abc264024882bd",
"bookmarklet/node_modules/acorn/dist/acorn.d.ts": "e4ea66b5df540b8ca861d770724783fb",
"bookmarklet/node_modules/acorn/dist/acorn.js": "e9a7e2cf81f15952f3d44619efc545d4",
"bookmarklet/node_modules/acorn/dist/acorn.d.mts": "e4ea66b5df540b8ca861d770724783fb",
"bookmarklet/node_modules/acorn/README.md": "99ecafaf780de1a563ab13f3b62968b8",
"bookmarklet/node_modules/acorn/package.json": "8dd8cedf1555064417351ec2f8c0f5b9",
"bookmarklet/node_modules/source-map-support/LICENSE.md": "f433e270f6b1d088c38b279d53048f5e",
"bookmarklet/node_modules/source-map-support/browser-source-map-support.js": "e5ff7158897f6111a19ff5bc94ee2bcf",
"bookmarklet/node_modules/source-map-support/source-map-support.js": "d37e9611ed19248fadecf6c7c49c372b",
"bookmarklet/node_modules/source-map-support/register-hook-require.js": "7b45d5dc09300b6161bbe3b0063f9d99",
"bookmarklet/node_modules/source-map-support/register.js": "e3a1e47483a703eb9f9c9f923ad8d2e9",
"bookmarklet/node_modules/source-map-support/README.md": "447e8907887fcdb195fed4288c57062e",
"bookmarklet/node_modules/source-map-support/package.json": "82a79198fa51b5a0924d409a6997335a",
"bookmarklet/node_modules/source-map/LICENSE": "b1ca6dbc0075d56cbd9931a75566cd44",
"bookmarklet/node_modules/source-map/CHANGELOG.md": "a3af94376054cec4d2e6fdcf2831d7e0",
"bookmarklet/node_modules/source-map/dist/source-map.min.js.map": "14382917698e37c1a0e91dd0138d87b1",
"bookmarklet/node_modules/source-map/dist/source-map.debug.js": "148520949cd049880dca366661da04a9",
"bookmarklet/node_modules/source-map/dist/source-map.js": "beb4133364679825b92ce1616e978f97",
"bookmarklet/node_modules/source-map/dist/source-map.min.js": "1fdaa5d6fe7f715979db66b43516119b",
"bookmarklet/node_modules/source-map/README.md": "eaeb80f692e37ce28209fdf876527559",
"bookmarklet/node_modules/source-map/package.json": "5f7feb368962c3130c5accf22ffd047c",
"bookmarklet/node_modules/source-map/source-map.js": "1bb9c1d35d2fbb3779c67306ca3d8070",
"bookmarklet/node_modules/source-map/lib/source-map-consumer.js": "ace24088d46d7c799dcaaffebfd0b0bb",
"bookmarklet/node_modules/source-map/lib/quick-sort.js": "dfeffc75906e8f42d235a55801ae2a42",
"bookmarklet/node_modules/source-map/lib/util.js": "17caa6910791c90d80d98be1d8b9034e",
"bookmarklet/node_modules/source-map/lib/base64-vlq.js": "10ab2672fb7feaa6e4a2ca651d2412f9",
"bookmarklet/node_modules/source-map/lib/mapping-list.js": "b43d49bb65a0e89b26e13a97de816cad",
"bookmarklet/node_modules/source-map/lib/binary-search.js": "250315731532fce9f782a6dcc6a0f569",
"bookmarklet/node_modules/source-map/lib/base64.js": "d6ba9a233e14b859b51f538c0b295953",
"bookmarklet/node_modules/source-map/lib/array-set.js": "e409c2198743fb3f9c3e5939358bc32e",
"bookmarklet/node_modules/source-map/lib/source-node.js": "c53b081a390b23d134d60c390843b5de",
"bookmarklet/node_modules/source-map/lib/source-map-generator.js": "85a051f0e4bdb90a4beafe62f6f1cedf",
"bookmarklet/node_modules/source-map/source-map.d.ts": "85653942d3090260ae5369fc65e9b6e9",
"bookmarklet/node_modules/terser/tools/props.html": "6252b38f6bc6a83268598df36589487b",
"bookmarklet/node_modules/terser/tools/exit.cjs": "af4419afb8945eb222c46701f1e22740",
"bookmarklet/node_modules/terser/tools/terser.d.ts": "95b65d922a01a77240954561d2f64a5f",
"bookmarklet/node_modules/terser/tools/domprops.js": "219050d0fb0445587c221ea285e4f9f3",
"bookmarklet/node_modules/terser/LICENSE": "bc583815069266a70963621b0ea9dee9",
"bookmarklet/node_modules/terser/bin/uglifyjs": "f0814f2fab9489a63d68446cdd2ad528",
"bookmarklet/node_modules/terser/bin/package.json": "d0cbe028548ede750e57ee41c308240f",
"bookmarklet/node_modules/terser/bin/terser": "b54eba26d62579504aac2f781212fd4e",
"bookmarklet/node_modules/terser/CHANGELOG.md": "a0522a51c1ccd7708f5a6b54b3de78ea",
"bookmarklet/node_modules/terser/dist/bundle.min.js": "a23108cd7f9b08a5d516893025107cb6",
"bookmarklet/node_modules/terser/dist/package.json": "a4b7515d263ae455ae9c0bceeeab8df8",
"bookmarklet/node_modules/terser/PATRONS.md": "1bd0223831442feb5e897bad5ea46014",
"bookmarklet/node_modules/terser/README.md": "ccb07aa946161fd8ee63ca4a0d64ac64",
"bookmarklet/node_modules/terser/main.js": "a5b0e77d114dcaa27a10f34a1ded4a30",
"bookmarklet/node_modules/terser/package.json": "bfd79fe7cf5bf2a0e1ed810cee71a2bf",
"bookmarklet/node_modules/terser/lib/compress/drop-side-effect-free.js": "33be2bf1ca2892c4dee6d8d975f436d4",
"bookmarklet/node_modules/terser/lib/compress/reduce-vars.js": "ca8c4ac006f13a27a725727a86c2d032",
"bookmarklet/node_modules/terser/lib/compress/index.js": "6df0eb5bb1317f3ca74307721acf8d94",
"bookmarklet/node_modules/terser/lib/compress/evaluate.js": "33067c1c19c1f4ea0f06dae68ad85b25",
"bookmarklet/node_modules/terser/lib/compress/inline.js": "7f916d910468c39d6b97d84fa7e2552c",
"bookmarklet/node_modules/terser/lib/compress/compressor-flags.js": "4b088ebdd2c0262bc35ebaf2a8d092fc",
"bookmarklet/node_modules/terser/lib/compress/common.js": "f39ee25fcf8796ff7857798af6d36da7",
"bookmarklet/node_modules/terser/lib/compress/drop-unused.js": "0f7ab1b4b8b415f3eacef843d967e4b0",
"bookmarklet/node_modules/terser/lib/compress/global-defs.js": "2fa84744425080c45d4db08fef5e8d92",
"bookmarklet/node_modules/terser/lib/compress/inference.js": "248152eff719076edb0a4cd82bcd5301",
"bookmarklet/node_modules/terser/lib/compress/native-objects.js": "a8e351d678a5f768361703801bdf135b",
"bookmarklet/node_modules/terser/lib/compress/tighten-body.js": "88ac2a38c46762d41bec113a3e19e358",
"bookmarklet/node_modules/terser/lib/size.js": "97bd1c2caf6b1c2f3760202b5f6cfeae",
"bookmarklet/node_modules/terser/lib/utils/index.js": "d06c24e8d60ff018b8fcbc116c5ca045",
"bookmarklet/node_modules/terser/lib/utils/first_in_statement.js": "910114a3735038a240d7abc9c485ce0b",
"bookmarklet/node_modules/terser/lib/minify.js": "b8db41d8d3e492dba720028f7dfa5cd6",
"bookmarklet/node_modules/terser/lib/parse.js": "dc4fe5ee156eb9b5d35170e3652a0e98",
"bookmarklet/node_modules/terser/lib/propmangle.js": "523fe0b03e269edf24c0f381d298d445",
"bookmarklet/node_modules/terser/lib/output.js": "a07c652d47f91328e3d5bff2eb3f823b",
"bookmarklet/node_modules/terser/lib/scope.js": "1b515293a173669cb3b1328af9d6e12b",
"bookmarklet/node_modules/terser/lib/sourcemap.js": "c830c208e9e7ceb09b819b41553b7fdc",
"bookmarklet/node_modules/terser/lib/cli.js": "f8270f9145827898ebceb3003d42909f",
"bookmarklet/node_modules/terser/lib/mozilla-ast.js": "73f8521d04fa08462ef570f937839c81",
"bookmarklet/node_modules/terser/lib/ast.js": "fd5338d7c28b37f1b8bedfc6ecee737d",
"bookmarklet/node_modules/terser/lib/equivalent-to.js": "2a3c6e670bab1092f6f4aa6d4b5303d9",
"bookmarklet/node_modules/terser/lib/transform.js": "3b46c1d32f178647c99d6279e265fd3f",
"bookmarklet/node_modules/@jridgewell/sourcemap-codec/types/sourcemap-codec.d.mts": "66c686a7f87e768ef80e863ce4989f02",
"bookmarklet/node_modules/@jridgewell/sourcemap-codec/types/sourcemap-codec.d.cts": "42b387789802c8e8c69ae6051d4bd8d7",
"bookmarklet/node_modules/@jridgewell/sourcemap-codec/types/scopes.d.cts": "c2720243c9da3ccba696fadfd4df378c",
"bookmarklet/node_modules/@jridgewell/sourcemap-codec/types/scopes.d.mts": "c2720243c9da3ccba696fadfd4df378c",
"bookmarklet/node_modules/@jridgewell/sourcemap-codec/types/sourcemap-codec.d.cts.map": "4ccba2ae7316b0d09516c222625967f7",
"bookmarklet/node_modules/@jridgewell/sourcemap-codec/types/strings.d.cts.map": "a08f5b521d520b141eb6a703ccc67072",
"bookmarklet/node_modules/@jridgewell/sourcemap-codec/types/scopes.d.mts.map": "91e99baefadb2f648434d300a58fa07b",
"bookmarklet/node_modules/@jridgewell/sourcemap-codec/types/strings.d.cts": "8d3c94109af37ef4e2b379e01be783d7",
"bookmarklet/node_modules/@jridgewell/sourcemap-codec/types/vlq.d.mts.map": "d9604a5cf24ea5d1940021bba9aecf0f",
"bookmarklet/node_modules/@jridgewell/sourcemap-codec/types/strings.d.mts": "8d3c94109af37ef4e2b379e01be783d7",
"bookmarklet/node_modules/@jridgewell/sourcemap-codec/types/scopes.d.cts.map": "91e99baefadb2f648434d300a58fa07b",
"bookmarklet/node_modules/@jridgewell/sourcemap-codec/types/strings.d.mts.map": "a08f5b521d520b141eb6a703ccc67072",
"bookmarklet/node_modules/@jridgewell/sourcemap-codec/types/vlq.d.cts.map": "d9604a5cf24ea5d1940021bba9aecf0f",
"bookmarklet/node_modules/@jridgewell/sourcemap-codec/types/sourcemap-codec.d.mts.map": "4ccba2ae7316b0d09516c222625967f7",
"bookmarklet/node_modules/@jridgewell/sourcemap-codec/types/vlq.d.cts": "748677e9206c7c7bc8f93851c9352807",
"bookmarklet/node_modules/@jridgewell/sourcemap-codec/types/vlq.d.mts": "8e1c09243fd6ee307775da91fa8e8134",
"bookmarklet/node_modules/@jridgewell/sourcemap-codec/LICENSE": "2327dcc62ba928de8438ea5881779911",
"bookmarklet/node_modules/@jridgewell/sourcemap-codec/dist/sourcemap-codec.umd.js": "1de5b40a19fb939ffa727639a253d48b",
"bookmarklet/node_modules/@jridgewell/sourcemap-codec/dist/sourcemap-codec.umd.js.map": "7b835cefb7f9cb489310a9254d46b9bc",
"bookmarklet/node_modules/@jridgewell/sourcemap-codec/dist/sourcemap-codec.mjs": "c7c6e6bccdbe92678796e2c01566b7b4",
"bookmarklet/node_modules/@jridgewell/sourcemap-codec/dist/sourcemap-codec.mjs.map": "c0902050f77f89eca553ff358eace152",
"bookmarklet/node_modules/@jridgewell/sourcemap-codec/README.md": "4d56cdc0ea11e39b7361723efb7c2af0",
"bookmarklet/node_modules/@jridgewell/sourcemap-codec/package.json": "74c5ab7104692485f60ac316cb1fd590",
"bookmarklet/node_modules/@jridgewell/sourcemap-codec/src/sourcemap-codec.ts": "fcaec321de723f3c815f2a12ea98aefa",
"bookmarklet/node_modules/@jridgewell/sourcemap-codec/src/strings.ts": "dbca5e6101c983f8ce56b607378a68ad",
"bookmarklet/node_modules/@jridgewell/sourcemap-codec/src/vlq.ts": "dc0c1a367983d63012502c4a638b0a8f",
"bookmarklet/node_modules/@jridgewell/sourcemap-codec/src/scopes.ts": "504138b6d86b175f3941cb08d6aa35d8",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/resolve.d.cts.map": "b7f56c5c59f11687602382ca812682cf",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/flatten-map.d.cts": "a45831b2594bd4242dee30bd51985cf0",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/flatten-map.d.mts": "5a451738aafac52612d778618a1e2c88",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/sourcemap-segment.d.mts.map": "cc4a36e469907367107cd08be7da0d94",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/trace-mapping.d.cts": "d73c4f83955625eb8f0bff72eaf645d6",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/trace-mapping.d.mts": "34db7c9503db72f622454493f7b58c64",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/binary-search.d.mts.map": "5f4052b465e26951fa0fdce970252d06",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/by-source.d.cts": "387962503ee8d1ccc3bf2ff02d015efc",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/sort.d.mts.map": "ca0c0608423332ef9cf0ad7bd0d9bd09",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/by-source.d.cts.map": "b8ba954ddd0a68e6c9a3a2d1ebc8e276",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/types.d.cts.map": "eb3474580181301a22ba165315d3b8ec",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/by-source.d.mts": "64fd9fb3c9f8c43b32ff2628002d766b",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/flatten-map.d.cts.map": "1c1704b58ffe21a1b0cb1a764fe55324",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/trace-mapping.d.mts.map": "9eccdd6f3a9a5e988078f7aa1176013b",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/strip-filename.d.cts.map": "bbec94a9d4a1f57aa7ed4c053c520fcc",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/resolve.d.mts": "82ed8e96d84f6f71afb2bb8bc4ce936e",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/flatten-map.d.mts.map": "1c1704b58ffe21a1b0cb1a764fe55324",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/types.d.cts": "80e22bcee2076bed0176c2942b58bab3",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/trace-mapping.d.cts.map": "9eccdd6f3a9a5e988078f7aa1176013b",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/types.d.mts": "4221d09132f867959ef0b68223185857",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/strip-filename.d.mts.map": "bbec94a9d4a1f57aa7ed4c053c520fcc",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/resolve.d.cts": "99bb5737d0c7e41711be7cc7ba9ffc20",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/strip-filename.d.mts": "7ced243b4db1e51213aaaa58f3a38b60",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/sort.d.cts.map": "ca0c0608423332ef9cf0ad7bd0d9bd09",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/by-source.d.mts.map": "b8ba954ddd0a68e6c9a3a2d1ebc8e276",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/strip-filename.d.cts": "1a59cecd8b1733a7d31767751b21ffd1",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/types.d.mts.map": "eb3474580181301a22ba165315d3b8ec",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/sourcemap-segment.d.cts": "ed9f4db0c39c60bfb09f761217ce430b",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/binary-search.d.mts": "2c73f7881cfbe77966618cac626f2fc1",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/binary-search.d.cts": "dcac612b4685ac77d49b93c788a0e970",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/sourcemap-segment.d.mts": "ed9f4db0c39c60bfb09f761217ce430b",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/binary-search.d.cts.map": "5f4052b465e26951fa0fdce970252d06",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/resolve.d.mts.map": "b7f56c5c59f11687602382ca812682cf",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/sort.d.mts": "5770aea4357e5f8baf8eb651ef0dcb05",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/sourcemap-segment.d.cts.map": "cc4a36e469907367107cd08be7da0d94",
"bookmarklet/node_modules/@jridgewell/trace-mapping/types/sort.d.cts": "c7439b0b25c468a1fc76c56b8a0c1b17",
"bookmarklet/node_modules/@jridgewell/trace-mapping/LICENSE": "2327dcc62ba928de8438ea5881779911",
"bookmarklet/node_modules/@jridgewell/trace-mapping/dist/trace-mapping.mjs.map": "856ee5f2db0a550fe0270c78bd653040",
"bookmarklet/node_modules/@jridgewell/trace-mapping/dist/trace-mapping.umd.js.map": "c7f4efbe11c761d68ce328b7e33d300d",
"bookmarklet/node_modules/@jridgewell/trace-mapping/dist/trace-mapping.umd.js": "84db805ca6377575ddfb6b67d7d4bb5a",
"bookmarklet/node_modules/@jridgewell/trace-mapping/dist/trace-mapping.mjs": "7f5b5d7b8c326902c2a56bf1e97b4522",
"bookmarklet/node_modules/@jridgewell/trace-mapping/README.md": "eaee0fe4efaf99fa4688d618c56d37b8",
"bookmarklet/node_modules/@jridgewell/trace-mapping/package.json": "4265d8b0d693d3d0793ae977aec6e4ec",
"bookmarklet/node_modules/@jridgewell/trace-mapping/src/sourcemap-segment.ts": "1a44c574e23323f394730938ff673353",
"bookmarklet/node_modules/@jridgewell/trace-mapping/src/strip-filename.ts": "7031535368da87989d2b2f6a0181b5a6",
"bookmarklet/node_modules/@jridgewell/trace-mapping/src/flatten-map.ts": "e60ef8d6e13cbd415374e6f55017391c",
"bookmarklet/node_modules/@jridgewell/trace-mapping/src/types.ts": "f66a0c402c96c125150c7bbba4e1e197",
"bookmarklet/node_modules/@jridgewell/trace-mapping/src/by-source.ts": "af965aedb6e4e227fe3beb1d7ab889a2",
"bookmarklet/node_modules/@jridgewell/trace-mapping/src/sort.ts": "53bde301186c4dc83b8a265760498394",
"bookmarklet/node_modules/@jridgewell/trace-mapping/src/trace-mapping.ts": "a782c674ae7b3e24bde043e1b79463b3",
"bookmarklet/node_modules/@jridgewell/trace-mapping/src/binary-search.ts": "d887d86e0e5c5a9187fed491b91145cc",
"bookmarklet/node_modules/@jridgewell/trace-mapping/src/resolve.ts": "a990a9f30edfa0803d13ef61e14e9ee9",
"bookmarklet/node_modules/@jridgewell/gen-mapping/types/sourcemap-segment.d.mts.map": "062c3322023a55cbedb57ff1d256c1fa",
"bookmarklet/node_modules/@jridgewell/gen-mapping/types/types.d.cts.map": "ed87c5e37b53cadd8cfb7337e06b9a94",
"bookmarklet/node_modules/@jridgewell/gen-mapping/types/gen-mapping.d.cts.map": "6485b3db62735b1e049ccabe08051ae0",
"bookmarklet/node_modules/@jridgewell/gen-mapping/types/set-array.d.mts.map": "15d3e39765592bb38aaddd9d814678ed",
"bookmarklet/node_modules/@jridgewell/gen-mapping/types/types.d.cts": "3fa6461985e4f3687ac17495748f6f88",
"bookmarklet/node_modules/@jridgewell/gen-mapping/types/types.d.mts": "8e95c40d36af0140f5b57a58f70e30c6",
"bookmarklet/node_modules/@jridgewell/gen-mapping/types/set-array.d.cts.map": "15d3e39765592bb38aaddd9d814678ed",
"bookmarklet/node_modules/@jridgewell/gen-mapping/types/types.d.mts.map": "ed87c5e37b53cadd8cfb7337e06b9a94",
"bookmarklet/node_modules/@jridgewell/gen-mapping/types/gen-mapping.d.mts.map": "6485b3db62735b1e049ccabe08051ae0",
"bookmarklet/node_modules/@jridgewell/gen-mapping/types/set-array.d.cts": "92d5d4f4f56383f6b597234088cf0bf3",
"bookmarklet/node_modules/@jridgewell/gen-mapping/types/gen-mapping.d.mts": "10cd3aec435786879490cc159b4e5d8b",
"bookmarklet/node_modules/@jridgewell/gen-mapping/types/sourcemap-segment.d.cts": "d1b37494d1848a4e0d5db06d71b1e692",
"bookmarklet/node_modules/@jridgewell/gen-mapping/types/set-array.d.mts": "92d5d4f4f56383f6b597234088cf0bf3",
"bookmarklet/node_modules/@jridgewell/gen-mapping/types/gen-mapping.d.cts": "fb98ff6fe5faa0b5899713fd84acac31",
"bookmarklet/node_modules/@jridgewell/gen-mapping/types/sourcemap-segment.d.mts": "d1b37494d1848a4e0d5db06d71b1e692",
"bookmarklet/node_modules/@jridgewell/gen-mapping/types/sourcemap-segment.d.cts.map": "062c3322023a55cbedb57ff1d256c1fa",
"bookmarklet/node_modules/@jridgewell/gen-mapping/LICENSE": "2327dcc62ba928de8438ea5881779911",
"bookmarklet/node_modules/@jridgewell/gen-mapping/dist/types/types.d.ts": "9f07bffd2120e0da063924d0f34bf84c",
"bookmarklet/node_modules/@jridgewell/gen-mapping/dist/types/gen-mapping.d.ts": "9232ad9811767a2b8a41a9776a7dc6c0",
"bookmarklet/node_modules/@jridgewell/gen-mapping/dist/types/set-array.d.ts": "a107537baca993fd9ea5f911c92b3b37",
"bookmarklet/node_modules/@jridgewell/gen-mapping/dist/types/sourcemap-segment.d.ts": "8f49beee50c40bcf21717dba46794bbc",
"bookmarklet/node_modules/@jridgewell/gen-mapping/dist/gen-mapping.umd.js.map": "494fc5c19771cce01d1b3d563e1ef4b6",
"bookmarklet/node_modules/@jridgewell/gen-mapping/dist/gen-mapping.mjs.map": "968cf44c0406f5726d30af2f36a4d636",
"bookmarklet/node_modules/@jridgewell/gen-mapping/dist/gen-mapping.mjs": "0f815d6db695c3ae1740f35ec65f9bf2",
"bookmarklet/node_modules/@jridgewell/gen-mapping/dist/gen-mapping.umd.js": "4fc2a2da64bc58eac36b06c020f0e214",
"bookmarklet/node_modules/@jridgewell/gen-mapping/README.md": "8f5c3629e0c857449cdcc727cd263066",
"bookmarklet/node_modules/@jridgewell/gen-mapping/package.json": "f2f77df9c5dbd9871b1bdb48dacc04a4",
"bookmarklet/node_modules/@jridgewell/gen-mapping/src/sourcemap-segment.ts": "fbd39da1b4e3d4cea7246e46dc0d558a",
"bookmarklet/node_modules/@jridgewell/gen-mapping/src/gen-mapping.ts": "6a7a489e21f76bffc1c66b06d3a17461",
"bookmarklet/node_modules/@jridgewell/gen-mapping/src/types.ts": "e9d5c7a36a284b240fe6697ea80a38ed",
"bookmarklet/node_modules/@jridgewell/gen-mapping/src/set-array.ts": "d0132ae39c9a5ccdfd524dd9c48931cb",
"bookmarklet/node_modules/@jridgewell/resolve-uri/LICENSE": "5e5f6ed6b602bd248e3493f8c6719a4b",
"bookmarklet/node_modules/@jridgewell/resolve-uri/dist/resolve-uri.umd.js": "1895d57b7b67bf99fa5f8e8eaa3d42b2",
"bookmarklet/node_modules/@jridgewell/resolve-uri/dist/resolve-uri.umd.js.map": "e23d83625ff27a2c77db2f7d1d4ae0b8",
"bookmarklet/node_modules/@jridgewell/resolve-uri/dist/types/resolve-uri.d.ts": "ea9a8d0c1f93d3e72f0021252fb0daeb",
"bookmarklet/node_modules/@jridgewell/resolve-uri/dist/resolve-uri.mjs": "e347d6373e3b34ca42d78d4ee4853af2",
"bookmarklet/node_modules/@jridgewell/resolve-uri/dist/resolve-uri.mjs.map": "270ac97012f3badf0a5c4e91ce757b0d",
"bookmarklet/node_modules/@jridgewell/resolve-uri/README.md": "be96ae01cc551045fe7759618ad35ae4",
"bookmarklet/node_modules/@jridgewell/resolve-uri/package.json": "5fa790a2ee02c9765d556544d9a02383",
"bookmarklet/node_modules/@jridgewell/source-map/types/source-map.d.mts.map": "90e08a51c3e44b4329acf8a2d31bf3b7",
"bookmarklet/node_modules/@jridgewell/source-map/types/source-map.d.mts": "cbd5846d2adf12a03da7770330897bbf",
"bookmarklet/node_modules/@jridgewell/source-map/types/source-map.d.cts": "cbd5846d2adf12a03da7770330897bbf",
"bookmarklet/node_modules/@jridgewell/source-map/types/source-map.d.cts.map": "90e08a51c3e44b4329acf8a2d31bf3b7",
"bookmarklet/node_modules/@jridgewell/source-map/LICENSE": "2327dcc62ba928de8438ea5881779911",
"bookmarklet/node_modules/@jridgewell/source-map/dist/source-map.mjs": "fcc601f89e96226b3b15b76e73005466",
"bookmarklet/node_modules/@jridgewell/source-map/dist/source-map.umd.js": "f79bfa03744793d02e94c0e4483956d7",
"bookmarklet/node_modules/@jridgewell/source-map/dist/source-map.mjs.map": "78364a3a20aeed3b27faa78aa74e1a9b",
"bookmarklet/node_modules/@jridgewell/source-map/dist/source-map.umd.js.map": "852eda811692915a7b7d16b196cc69ae",
"bookmarklet/node_modules/@jridgewell/source-map/README.md": "9f2e9b53ff8bc006433bc0c73ef1afaf",
"bookmarklet/node_modules/@jridgewell/source-map/package.json": "afd37732f22b42059baac046e7ae4253",
"bookmarklet/node_modules/@jridgewell/source-map/src/source-map.ts": "18332a7aa2e65e9cab5c5d7dcbb11ad6",
"bookmarklet/node_modules/buffer-from/LICENSE": "46513463e8f7d9eb671a243f0083b2c6",
"bookmarklet/node_modules/buffer-from/index.js": "4e815c6577adaeff617a870059f72d57",
"bookmarklet/node_modules/buffer-from/readme.md": "6f0403868020196e40d3a7c00b166b33",
"bookmarklet/node_modules/buffer-from/package.json": "5d307ad7d2ccde25a82e944fb224ebe2",
"bookmarklet/build.js": "cd6229ee3cb988d0b8e102f7e482f64e",
"bookmarklet/README.md": "8876f89aff8457152c78e024afd9f1ce",
"bookmarklet/package-lock.json": "f5cb62a39895f91cb097f988651f0721",
"bookmarklet/package.json": "29e25aa38410ace1228077efff2f7d3c",
"bookmarklet/src/utils/scoring.js": "1f6312adc20fc3c3f9bf3f3cc000cea1",
"bookmarklet/src/main.js": "8f19c917bb463cbcf7618a03c41e6afe",
"bookmarklet/src/extractors/generic.js": "d5dfdefff14ef26cb98d80aaad58f42f",
"bookmarklet/src/extractors/cookpad.js": "9de7b314c12e6e2f85dfd9fa1af5d3b2",
"bookmarklet/src/extractors/instagram.js": "d491e3e3b1eea28b67a79613f061fd6e",
"main.dart.js": "bb33ac5a2dc9b07f72d995ba4d4b68f4",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"favicon.png": "8abcf3fb67bc3c44156352eda6ed8a73",
"icons/Icon-192.png": "d78640f9bf91b840dff8fbd3ed8ea577",
"icons/Icon-maskable-192.png": "d78640f9bf91b840dff8fbd3ed8ea577",
"icons/Icon-maskable-512.png": "e7706422e12a716bc87ef1cb6f811133",
"icons/Icon-512.png": "e7706422e12a716bc87ef1cb6f811133",
"manifest.json": "275d6a7fc6b81815a940e731ab230410",
"assets/NOTICES": "b4ee2f6cca89ff1b97d213d881104275",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "73674bcd7c7214dda7255c74f213af43",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/AssetManifest.bin": "d553e3189d408ce211bafdd4acf8dd74",
"assets/fonts/MaterialIcons-Regular.otf": "df24592f8cb8c39dfc5f24106335076e",
"assets/assets/icons/crossed_cutlery.svg": "5f5ad4f9c7921aa1bbd6572ab88f063d",
"assets/assets/icons/meat.png": "892644c7074f2e1a23bedf78fe619638",
"favicon-32x32.png": "18e080decf84da62e3b7496f3be2e061",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
