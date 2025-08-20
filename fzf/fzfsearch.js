#!/usr/bin/env node

const fs = require('fs');

// Read and parse the JSON file
const data = JSON.parse(fs.readFileSync('sw.json', 'utf8'));

// Function to recursively search through nodes
function searchNodes(nodes, query, results = []) {
  for (const node of nodes) {
    // Check if this node matches our search criteria
    const matches = (
      (node.window_properties && (
        (node.window_properties.title && node.window_properties.title.toLowerCase().includes(query)) ||
        (node.window_properties.instance && node.window_properties.instance.toLowerCase().includes(query)) ||
        (node.window_properties.class && node.window_properties.class.toLowerCase().includes(query))
      )) ||
      (node.app_id && node.app_id.toLowerCase().includes(query)) ||
      (node.name && node.name.toLowerCase().includes(query))
    );

    if (matches) {
      results.push({
        appname: node.window_properties ? node.window_properties.class || 'N/A' : 'N/A',
        pid: node.pid || 'N/A',
        appid: node.app_id || 'N/A',
        title: node.window_properties ? node.window_properties.title || 'N/A' : node.name || 'N/A'
      });
    }

    // Recursively search child nodes
    if (node.nodes && node.nodes.length > 0) {
      searchNodes(node.nodes, query, results);
    }

    // Recursively search floating nodes
    if (node.floating_nodes && node.floating_nodes.length > 0) {
      searchNodes(node.floating_nodes, query, results);
    }
  }
  return results;
}

// Function to handle search
function performSearch(query) {
  const lowercaseQuery = query.toLowerCase();
  const results = searchNodes(data.nodes, lowercaseQuery);
  
  // Output results in JSON format
  console.log(JSON.stringify(results, null, 2));
}

// Handle command line arguments
if (process.argv.length < 3) {
  console.error('Usage: node script.js <search-query>');
  process.exit(1);
}

// Combine all arguments after the script name into a single search query
const searchQuery = process.argv.slice(2).join(' ');
performSearch(searchQuery);