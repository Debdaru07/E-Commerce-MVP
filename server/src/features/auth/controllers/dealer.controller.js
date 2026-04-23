import supabase from '../../../shared/database/supabase.js'

/**
 * DEALER SIGNUP
 */
export const signupDealer = async (req, res) => {
  if (!req.body) {
    return res.status(400).json({ error: 'Invalid JSON body' })
  }

  const { email, password, full_name } = req.body

  if (!email || !password || !full_name) {
    return res.status(400).json({
      error: 'Email, password and full name are required'
    })
  }

  try {
    // 1️⃣ Create auth user
    const { data: authData, error: authError } =
      await supabase.auth.admin.createUser({
        email,
        password,
        email_confirm: true
      })

    if (authError) {
      return res.status(409).json({ error: authError.message })
    }

    // 2️⃣ Upsert profile (SAFE)
    const { error: profileError } = await supabase
      .from('profiles')
      .upsert({
        id: authData.user.id,
        role: 'DEALER',
        full_name,
        is_active: true
      })

    if (profileError) throw profileError

    res.status(201).json({
      message: 'Dealer registered successfully'
    })

  } catch (err) {
    console.error(err)
    res.status(500).json({ error: 'Server error' })
  }
}

/**
 * DEALER LOGIN
 */
export const loginDealer = async (req, res) => {
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
    // 1️⃣ Login via Supabase Auth
    const { data, error } =
      await supabase.auth.signInWithPassword({
        email,
        password
      })

    if (error) {
      return res.status(401).json({ error: 'Invalid credentials' })
    }

    // 2️⃣ Fetch dealer profile
    const { data: profile, error: profileError } = await supabase
      .from('profiles')
      .select('role, is_active')
      .eq('id', data.user.id)
      .single()

    if (profileError || !profile) {
      return res.status(403).json({ error: 'Profile not found' })
    }

    if (profile.role !== 'DEALER') {
      return res.status(403).json({ error: 'Access denied' })
    }

    if (!profile.is_active) {
      return res.status(403).json({ error: 'Dealer account disabled' })
    }

    res.json({
      message: 'Dealer login successful',
      access_token: data.session.access_token
    })

  } catch (err) {
    console.error(err)
    res.status(500).json({ error: 'Server error' })
  }
}
