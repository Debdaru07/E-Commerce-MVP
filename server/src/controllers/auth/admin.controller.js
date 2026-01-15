import supabase from '../../config/supabase.js'

export const loginAdmin = async (req, res) => {
  // 🛡️ SAFETY GUARD (CRITICAL)
  if (!req.body) {
    return res.status(400).json({
      error: 'Request body missing or invalid JSON'
    })
  }

  const { email, password } = req.body

  if (!email || !password) {
    return res.status(400).json({
      error: 'Email and password are required'
    })
  }

  try {
    const { data, error } =
      await supabase.auth.signInWithPassword({
        email,
        password
      })

    if (error) {
      return res.status(401).json({ error: 'Invalid credentials' })
    }

    const userId = data.user.id

    const { data: profile, error: profileError } = await supabase
      .from('profiles')
      .select('role, is_active')
      .eq('id', userId)
      .single()

    if (profileError || !profile) {
      return res.status(403).json({ error: 'Profile not found' })
    }

    if (profile.role !== 'ADMIN') {
      return res.status(403).json({ error: 'Access denied' })
    }

    if (!profile.is_active) {
      return res.status(403).json({ error: 'Admin account disabled' })
    }

    res.json({
      message: 'Admin login successful',
      access_token: data.session.access_token
    })

  } catch (err) {
    console.error(err)
    res.status(500).json({ error: 'Server error' })
  }
}
