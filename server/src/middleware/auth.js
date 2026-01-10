import supabase from '../config/supabase.js'

export const verifyToken = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization

    if (!authHeader) {
      return res.status(401).json({ error: 'Authorization header missing' })
    }

    const token = authHeader.split(' ')[1]

    if (!token) {
      return res.status(401).json({ error: 'Token missing' })
    }

    // Verify token with Supabase
    const { data, error } = await supabase.auth.getUser(token)

    if (error || !data?.user) {
      return res.status(401).json({ error: 'Invalid or expired token' })
    }

    // Fetch user profile
    const { data: profile, error: profileError } = await supabase
      .from('profiles')
      .select('role, is_active')
      .eq('id', data.user.id)
      .single()

    if (profileError || !profile) {
      return res.status(403).json({ error: 'Profile not found' })
    }

    if (!profile.is_active) {
      return res.status(403).json({ error: 'Account disabled' })
    }

    // Attach user to request
    req.user = {
      id: data.user.id,
      role: profile.role
    }

    next()
  } catch (err) {
    console.error(err)
    res.status(500).json({ error: 'Authentication failed' })
  }
}
