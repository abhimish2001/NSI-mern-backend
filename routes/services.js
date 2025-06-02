import express from "express";
import Services from "../models/Services.js";

const router = express.Router();

router.get("/", async (req, res) => {
  try {
    const services = await Services.find();
    res.json(services);
  } catch (err) {
    res.status(500).json({ error: "Failed to fetch testimonials" });
  }
});

export default router;
