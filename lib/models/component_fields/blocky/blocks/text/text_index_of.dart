const block_text_index_of = {
  "type": 'text_indexOf',
  "kind": 'block',
  "fields": {
    "END": 'FIRST',
  },
  "inputs": {
    "VALUE": {
      "block": {
        "type": 'variables_get',
        "fields": {
          "VAR": {
            "name": 'text',
          },
        },
      },
    },
    "FIND": {
      "shadow": {
        "type": 'text',
        "fields": {
          "TEXT": 'abc',
        },
      },
    },
  },
};