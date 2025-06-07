import express from "express";
import Teachers from "../models/Teacher.js";

const router = express.Router();

router.get("/", async (req, res) => {
  try {
    const services = await Teachers.find();
    res.json(services);
  } catch (err) {
    res.status(500).json({ error: "Failed to fetch teachers" });
  }
});

export default router;
