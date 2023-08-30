// documentschema.js
const mongoose = require('mongoose');

const documentSchema = new mongoose.Schema({
  id_proyecto: {
    type: String,
    required: true,
  },
  content: {
    type: Object,
    required: true,
  },
});

const Document = mongoose.model('Document', documentSchema);

module.exports = Document;
