import supabase from '../../config/supabase.js'

export const signupConsumer = async (req, res) => {
  const { email, password, full_name } = req.body

  try {
    const { data: authData, error: authError } =
      await supabase.auth.admin.createUser({
        email,
        password,
        email_confirm: true
      })

    if (authError) throw authError

    // ✅ IMPORTANT: store email in profiles
    const { error: profileError } = await supabase
      .from('profiles')
      .insert({
        id: authData.user.id,
        email,                // 👈 FIX
        role: 'CONSUMER',
        full_name,
        is_active: true
      })

    if (profileError) throw profileError

    res.status(201).json({ message: 'Consumer registered successfully' })
  } catch (err) {
    res.status(400).json({ error: err.message })
  }
}

export const loginConsumer = async (req, res) => {
  const { email, password } = req.body

  if (!email || !password) {
    return res.status(400).json({
      error: 'Email and password are required'
    })
  }

  try {
    // 1️⃣ Login using Supabase Auth
    const { data, error } =
      await supabase.auth.signInWithPassword({
        email,
        password
      })

    if (error) {
      return res.status(401).json({ error: 'Invalid credentials' })
    }

    // 2️⃣ Fetch profile
    const { data: profile, error: profileError } = await supabase
      .from('profiles')
      .select('role, is_active')
      .eq('id', data.user.id)
      .single()

    if (profileError || !profile) {
      return res.status(403).json({ error: 'Profile not found' })
    }

    // 3️⃣ Role check
    if (profile.role !== 'CONSUMER') {
      return res.status(403).json({ error: 'Access denied' })
    }

    if (!profile.is_active) {
      return res.status(403).json({ error: 'Account disabled' })
    }

    // 4️⃣ Success
    res.json({
      message: 'Consumer login successful',
      access_token: data.session.access_token
    })

  } catch (err) {
    res.status(500).json({ error: err.message })
  }
}

