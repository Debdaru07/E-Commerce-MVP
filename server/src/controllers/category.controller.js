import supabase from '../config/supabase.js'

export const getCategories = async (req, res) => {
    try {       

        const { data, error } = await supabase  
            .from('categories')
            .select('*')

        if (error) throw error

        res.json(data)
    } catch (err) {
        res.status(500).json({ error: err.message })
    }
}

export const createCategory = async (req, res) => {
  try {
    console.log('RAW BODY:', req.body)
    console.log('TYPEOF BODY:', typeof req.body)

    const { name, description } = req.body || {}

    console.log('PARSED:', { name, description })

    if (!name) {
      return res.status(400).json({ error: 'Category name is required' })
    }

    const result = await supabase
      .from('categories')
      .insert([{ name, description }])
      .select()

    console.log('SUPABASE RESULT:', result)

    if (result.error) {
      console.error('SUPABASE ERROR:', result.error)
      return res.status(500).json({
        error: result.error.message,
        details: result.error
      })
    }

    res.status(201).json({
      message: 'Category created successfully',
      category: result.data[0]
    })
  } catch (err) {
    console.error('UNCAUGHT ERROR:', err)
    res.status(500).json({
      error: err.message,
      stack: err.stack
    })
  }
}

export const updateCategory = async (req, res) => {
  const { categoryId } = req.params
  const { name, icon, is_active } = req.body

  // ✅ Validate
  if (!categoryId) {
    return res.status(400).json({ error: 'Category ID is required' })
  }

  if (name === undefined && icon === undefined && is_active === undefined) {
    return res.status(400).json({
      error: 'At least one field (name, icon, is_active) is required'
    })
  }

  try {
    // Build update object dynamically
    const updateData = {}
    if (name !== undefined) updateData.name = name
    if (icon !== undefined) updateData.icon = icon
    if (is_active !== undefined) updateData.is_active = is_active

    const { data, error } = await supabase
      .from('categories')
      .update(updateData)
      .eq('id', categoryId)
      .select()

    if (error) {
      return res.status(500).json({ error: error.message })
    }

    if (!data || data.length === 0) {
      return res.status(404).json({ error: 'Category not found' })
    }

    res.json({
      message: 'Category updated successfully',
      category: data[0]
    })

  } catch (err) {
    res.status(500).json({ error: err.message })
  }
}


