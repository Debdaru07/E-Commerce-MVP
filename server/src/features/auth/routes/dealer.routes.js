import { Router } from 'express'
import {
  signupDealer,
  loginDealer
} from '../controllers/dealer.controller.js'

const router = Router()

/**
 * DEALER SIGNUP
 * Allowed (unlike admin)
 */
router.post('/signup', signupDealer)

/**
 * DEALER LOGIN
 */
router.post('/login', loginDealer)

export default router
