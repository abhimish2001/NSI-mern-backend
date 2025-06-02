import mongoose from "mongoose";

// Subcategory schema (embedded in Service)
const subcategorySchema = new mongoose.Schema({
  id: Number,
  name: String,
  description: String,
  image: String,
});

// Service schema
const serviceSchema = new mongoose.Schema({
  id: Number,
  name: String,
  description: String,
  image: String,
  displayOrder: Number,
  isActive: Boolean,
  createdOn: Date,
  createdBy: String,
  updatedOn: Date,
  updatedBy: String,
  subcategories: [subcategorySchema], // array of subcategories
});

// Service model
const Service = mongoose.model("Service", serviceSchema);

export default Service;
