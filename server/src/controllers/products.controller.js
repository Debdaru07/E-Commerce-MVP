import supabase from '../config/supabase.js'

/**
 * PUBLIC / CONSUMER
 * Get all active products
 */
export const getAllProducts = async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('products')
      .select('*')
      .eq('is_active', true)

    if (error) throw error

    res.json(data)
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
}

/**
 * DEALER
 * Create a product (dealer owns it)
 */
export const createProduct = async (req, res) => {
  const dealerId = req.user.id // will come from JWT later
  const { title, description, unit_price, stock, category_id } = req.body

  try {
    const { error } = await supabase.from('products').insert({
      dealer_id: dealerId,
      category_id,
      title,
      description,
      unit_price,
      stock,
      is_active: true
    })

    if (error) throw error

    res.status(201).json({ message: 'Product created successfully' })
  } catch (err) {
    res.status(500).json({ error: err.message })
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
    const { error } = await supabase
      .from('products')
      .update(req.body)
      .eq('id', id)
      .eq('dealer_id', dealerId)

    if (error) throw error

    res.json({ message: 'Product updated successfully' })
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
}

/**
 * DEALER
 * Delete own product
 */
export const deleteProduct = async (req, res) => {
  const dealerId = req.user.id
  const { id } = req.params

  try {
    const { error } = await supabase
      .from('products')
      .delete()
      .eq('id', id)
      .eq('dealer_id', dealerId)

    if (error) throw error

    res.json({ message: 'Product deleted successfully' })
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
}
