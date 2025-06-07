import mongoose from "mongoose";

const subcategorySchema = new mongoose.Schema({
  id: Number,
  name: String,
  price: Number,
  courseTypes: [String], // e.g. ["HomeSession", "Online"]
});

const expertiseSchema = new mongoose.Schema({
  mainCategoryId: Number,
  mainCategoryName: String,
  subcategories: [subcategorySchema],
});

const teacherSchema = new mongoose.Schema({
  name: { type: String, required: true },
  profileImage: String,
  experienceYears: Number,
  bio: String,
  expertise: [expertiseSchema],
});

const Teacher = mongoose.model("Teacher", teacherSchema);

export default Teacher;
