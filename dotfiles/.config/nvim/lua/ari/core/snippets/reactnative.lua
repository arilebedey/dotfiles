local ls = require("luasnip")

ls.add_snippets("javascript", {


  -- React Native Component Boilerplate
  ls.snippet("rnc", {
    ls.text_node({
      "import React from 'react';",
      "import { View, Text, StyleSheet } from 'react-native';",
      "",
      "const ",
    }),
    ls.insert_node(1, "ComponentName"),
    ls.text_node({
      " = () => {",
      "  return (",
      "    <View style={styles.container}>",
      "      <Text>",
    }),
    ls.insert_node(2, "Hello, World!"),
    ls.text_node({
      "</Text>",
      "    </View>",
      "  );",
      "};",
      "",
      "const styles = StyleSheet.create({",
      "  container: {",
      "    flex: 1,",
      "    justifyContent: 'center',",
      "    alignItems: 'center',",
      "  },",
      "});",
      "",
      "export default ",
    }),
    ls.insert_node(1),
    ls.text_node(";"),
  }),


  -- React Native useState Hook
  ls.snippet("us", {
    ls.text_node("const ["),
    ls.insert_node(1, "state"),
    ls.text_node(", set"),
    ls.function_node(function(args)
      return args[1][1]:gsub("^%l", string.upper)
    end, { 1 }),
    ls.text_node("] = useState("),
    ls.insert_node(2, "initialValue"),
    ls.text_node(");"),
  }),


  -- React Native StyleSheet Boilerplate
  ls.snippet("ss", {
    ls.text_node({
      "const styles = StyleSheet.create({",
      "  ",
    }),
    ls.insert_node(1, "container"),
    ls.text_node({
      ": {",
      "    ",
    }),
    ls.insert_node(2, "flex: 1, justifyContent: 'center', alignItems: 'center'"),
    ls.text_node({
      ",",
      "  },",
      "});",
    }),
  }),


  -- FlatList Snippet
  ls.snippet("flatlist", {
    ls.text_node({
      "import React from 'react';",
      "import { FlatList, Text, View } from 'react-native';",
      "",
      "const ",
    }),
    ls.insert_node(1, "ListComponent"),
    ls.text_node({
      " = () => {",
      "  const data = [",
      "    { key: '1', value: 'Item 1' },",
      "    { key: '2', value: 'Item 2' },",
      "  ];",
      "",
      "  return (",
      "    <FlatList",
      "      data={data}",
      "      renderItem={({ item }) => (",
      "        <View>",
      "          <Text>{item.value}</Text>",
      "        </View>",
      "      )}",
      "      keyExtractor={(item) => item.key}",
      "    />",
      "  );",
      "};",
      "",
      "export default ",
    }),
    ls.insert_node(1),
    ls.text_node(";"),
  }),
})

return ls
