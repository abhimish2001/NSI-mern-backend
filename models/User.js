import mongoose from "mongoose";

const userSchema = new mongoose.Schema(
  {
    fname: { type: String, required: true },
    lname: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    role: { type: String, enum: ["Student", "Teacher"], required: true },

    // Optional but useful fields
    phone: { type: String },
    profileImage: { type: String, default: "" },
    isActive: { type: Boolean, default: true },
    gender: {
      type: String,
      enum: ["Male", "Female", "Other"],
      default: "Other",
    },
    dob: { type: Date },
    address: { type: String },
    bio: { type: String }, // especially for teachers
  },
  { timestamps: true }
);

export default mongoose.model("User", userSchema);
