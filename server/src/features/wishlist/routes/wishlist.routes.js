import { Router } from 'express'
import { verifyToken } from '../../../shared/middleware/auth.js'
import { requireRole } from '../../../shared/middleware/role.js'
import {
  addToWishlist,
  getWishlist,
  removeFromWishlist
} from '../controllers/wishlist.controller.js'

const router = Router()

/**
 * ADD PRODUCT TO WISHLIST (CONSUMER)
 * POST /wishlist
 */
router.post(
  '/',
  verifyToken,
  requireRole('CONSUMER'),
  addToWishlist
)

/**
 * GET LOGGED-IN CONSUMER WISHLIST
 * GET /wishlist
 */
router.get(
  '/',
  verifyToken,
  requireRole('CONSUMER'),
  getWishlist
)

/**
 * REMOVE PRODUCT FROM WISHLIST
 * DELETE /wishlist/:productId
 */
router.delete(
  '/:productId',
  verifyToken,
  requireRole('CONSUMER'),
  removeFromWishlist
)

export default router
