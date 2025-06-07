import express from "express";
import Teacher from "../models/teachers";

const router = express.Router();

router.get("/", async (req, res) => {
  try {
    const services = await Teacher.find();
    res.json(services);
  } catch (err) {
    res.status(500).json({ error: "Failed to fetch teachers" });
  }
});

export default router;
