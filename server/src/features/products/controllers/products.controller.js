import { ProductService } from '../services/ProductService.js'

const productService = new ProductService()

/**
 * PUBLIC / CONSUMER
 * Get all active products
 */
export const getAllProducts = async (req, res) => {
  try {
    const {
      title,
      description,
      category,
      sortBy = 'created_at',
      order = 'desc'
    } = req.query

    const filters = {
      title,
      description,
      category,
      sortBy,
      order
    }

    const products = await productService.getAllProducts(filters)
    res.json(products)
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
}

/**
 * DEALER
 * Create a product (dealer owns it)
 */
export const createProduct = async (req, res) => {
  if (!req.user) {
    return res.status(401).json({ error: 'Unauthorized' })
  }

  const dealerId = req.user.id

  try {
    const product = await productService.createProduct(req.body, dealerId)
    res.status(201).json({
      message: 'Product created successfully',
      product
    })
  } catch (err) {
    res.status(400).json({ error: err.message })
  }
}

/**
 * DEALER
 * Update own product
 */
export const updateProduct = async (req, res) => {
  if (!req.user) {
    return res.status(401).json({ error: 'Unauthorized' })
  }

  const dealerId = req.user.id
  const { id } = req.params

  try {
    const product = await productService.updateProduct(id, req.body, dealerId)
    res.json({
      message: 'Product updated successfully',
      product
    })
  } catch (err) {
    if (err.message.includes('not found') || err.message.includes('not owned')) {
      return res.status(404).json({ error: err.message })
    }
    res.status(400).json({ error: err.message })
  }
}

/**
 * DEALER
 * Delete own product
 */
export const deleteProduct = async (req, res) => {
  if (!req.user) {
    return res.status(401).json({ error: 'Unauthorized' })
  }

  const dealerId = req.user.id
  const { id } = req.params

  try {
    await productService.deleteProduct(id, dealerId)
    res.json({ message: 'Product deleted successfully' })
  } catch (err) {
    if (err.message.includes('not found') || err.message.includes('not owned')) {
      return res.status(404).json({ error: err.message })
    }
    res.status(500).json({ error: err.message })
  }
}

/**
 * DEALER
 * Get all products created by the logged-in dealer
 */
export const getDealerProducts = async (req, res) => {
  if (!req.user) {
    return res.status(401).json({ error: 'Unauthorized' })
  }

  const dealerId = req.user.id
  const { sortBy = 'created_at', order = 'desc' } = req.query

  try {
    const products = await productService.getDealerProducts(dealerId)
    res.json(products)
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
}
