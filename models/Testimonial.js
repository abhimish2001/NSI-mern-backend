import mongoose from "mongoose";

const testimonialSchema = new mongoose.Schema({
  name: String,
  contact: String,
  review: String,
});

const Testimonial = mongoose.model("Testimonial", testimonialSchema);

export default Testimonial;
