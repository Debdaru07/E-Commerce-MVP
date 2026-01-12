import supabase from '../config/supabase.js'

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

    let query = supabase
      .from('products')
      .select('*')
      .eq('is_active', true)

    if (title) {
      query = query.ilike('title', `%${title}%`)
    }

    if (description) {
      query = query.ilike('description', `%${description}%`)
    }

    if (category) {
      query = query.eq('category_id', category)
    }

    query = query.order(sortBy, { ascending: order === 'asc' })

    const { data, error } = await query

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
  if (!req.user) {
    return res.status(401).json({ error: 'Unauthorized' })
  }

  const dealerId = req.user.id
  const { title, description, unit_price, stock, category_id } = req.body

  if (!title || !unit_price || !category_id) {
    return res.status(400).json({
      error: 'title, unit_price and category_id are required'
    })
  }

  try {
    const { data, error } = await supabase
      .from('products')
      .insert({
        dealer_id: dealerId,
        category_id,
        title,
        description,
        unit_price,
        stock,
        is_active: true
      })
      .select()

    if (error) throw error

    res.status(201).json({
      message: 'Product created successfully',
      product: data[0]
    })
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
  const { title, description, unit_price, stock, category_id, is_active } = req.body

  const updateData = {}
  if (title !== undefined) updateData.title = title
  if (description !== undefined) updateData.description = description
  if (unit_price !== undefined) updateData.unit_price = unit_price
  if (stock !== undefined) updateData.stock = stock
  if (category_id !== undefined) updateData.category_id = category_id
  if (is_active !== undefined) updateData.is_active = is_active

  if (Object.keys(updateData).length === 0) {
    return res.status(400).json({ error: 'No valid fields to update' })
  }

  try {
    const { data, error } = await supabase
      .from('products')
      .update(updateData)
      .eq('id', id)
      .eq('dealer_id', dealerId)
      .select()

    if (error) throw error

    if (!data || data.length === 0) {
      return res.status(404).json({
        error: 'Product not found or not owned by dealer'
      })
    }

    res.json({
      message: 'Product updated successfully',
      product: data[0]
    })
  } catch (err) {
    res.status(500).json({ error: err.message })
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
    const { data, error } = await supabase
      .from('products')
      .delete()
      .eq('id', id)
      .eq('dealer_id', dealerId)
      .select()

    if (error) throw error

    if (!data || data.length === 0) {
      return res.status(404).json({
        error: 'Product not found or not owned by dealer'
      })
    }

    res.json({ message: 'Product deleted successfully' })
  } catch (err) {
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
    const { data, error } = await supabase
      .from('products')
      .select('*')
      .eq('dealer_id', dealerId)
      .order(sortBy, { ascending: order === 'asc' })

    if (error) throw error

    res.json(data)
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
}
