import express from 'express'
import { verifyToken } from '../middleware/auth.js'
import { getProfile } from '../controllers/user.controller.js'

const router = express.Router()

router.get('/profile', verifyToken, getProfile)

export default router
