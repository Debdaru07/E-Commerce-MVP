import supabase from '../../../shared/database/supabase.js'

/**
 * Add product to wishlist
 */
export const addToWishlist = async (req, res) => {
  const { product_id } = req.body
  const userId = req.user.id

  if (!product_id) {
    return res.status(400).json({ error: 'product_id is required' })
  }

  const { error } = await supabase
    .from('wishlist')
    .insert({
      user_id: userId,
      product_id
    })

  if (error) {
    return res.status(400).json({ error: error.message })
  }

  res.status(201).json({ message: 'Added to wishlist' })
}

/**
 * Get logged-in consumer wishlist
 */
export const getWishlist = async (req, res) => {
  const userId = req.user.id

  const { data, error } = await supabase
    .from('wishlist')
    .select(`
      id,
      created_at,
      products (
        id,
        title,
        description,
        unit_price
      )
    `)
    .eq('user_id', userId)

  if (error) {
    return res.status(500).json({ error: error.message })
  }

  res.json(data)
}

/**
 * Remove product from wishlist
 */
export const removeFromWishlist = async (req, res) => {
  const userId = req.user.id
  const { productId } = req.params

  const { data, error } = await supabase
    .from('wishlist')
    .delete()
    .eq('user_id', userId)
    .eq('product_id', productId)
    .select()

  if (error) {
    return res.status(500).json({ error: error.message })
  }

  if (!data || data.length === 0) {
    return res.status(404).json({ error: 'Wishlist item not found' })
  }

  res.json({ message: 'Removed from wishlist' })
}
