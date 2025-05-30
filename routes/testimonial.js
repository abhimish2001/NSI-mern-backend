import express from "express";
import Testimonial from "../models/Testimonial.js";

const router = express.Router();

router.get("/", async (req, res) => {
  try {
    const testimonials = await Testimonial.find();
    res.json(testimonials);
  } catch (err) {
    res.status(500).json({ error: "Failed to fetch testimonials" });
  }
});

export default router;
