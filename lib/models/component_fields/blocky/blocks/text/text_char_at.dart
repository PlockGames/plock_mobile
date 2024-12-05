const block_text_char_at = {
  "type": 'text_charAt',
  "kind": 'block',
  "fields": {
    "WHERE": 'FROM_START',
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
  },
};