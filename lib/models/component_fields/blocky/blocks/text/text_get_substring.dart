const block_text_get_substring = {
  "type": 'text_getSubstring',
  "kind": 'block',
  "fields": {
    "WHERE1": 'FROM_START',
    "WHERE2": 'FROM_START',
  },
  "inputs": {
    "STRING": {
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