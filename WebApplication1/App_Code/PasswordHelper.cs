using System;
using System.Security.Cryptography;

namespace WebApplication1
{
    /// <summary>
    /// PBKDF2 tabanl&#305; &#351;ifre hashleme ve do&#287;rulama yard&#305;mc&#305;s&#305;.
    /// Format: 4 byte iterasyon say&#305;s&#305; + 16 byte salt + 20 byte hash = 40 byte &#8594; Base64
    /// </summary>
    public static class PasswordHelper
    {
        private const int SaltSize   = 16;   // 128 bit
        private const int HashSize   = 20;   // 160 bit (SHA-1 uyumlu)
        private const int Iterations = 10000;
        private const int TotalBytes = 4 + SaltSize + HashSize; // 40 byte

        /// <summary>&#350;ifreyi PBKDF2 ile hashler ve Base64 string d&#246;nd&#252;r&#252;r.</summary>
        public static string HashPassword(string password)
        {
            byte[] salt = new byte[SaltSize];
            using (var rng = new RNGCryptoServiceProvider())
                rng.GetBytes(salt);

            byte[] hash = Pbkdf2(password, salt, Iterations, HashSize);

            byte[] result = new byte[TotalBytes];
            Buffer.BlockCopy(BitConverter.GetBytes(Iterations), 0, result, 0, 4);
            Buffer.BlockCopy(salt,  0, result, 4,            SaltSize);
            Buffer.BlockCopy(hash,  0, result, 4 + SaltSize, HashSize);

            return Convert.ToBase64String(result);
        }

        /// <summary>D&#252;z &#351;ifreyi sakl&#305;nan hash ile kar&#351;&#305;la&#351;t&#305;r&#305;r.</summary>
        public static bool Verify(string password, string storedHash)
        {
            try
            {
                byte[] bytes = Convert.FromBase64String(storedHash);
                if (bytes.Length != TotalBytes) return false;

                int iterations = BitConverter.ToInt32(bytes, 0);

                byte[] salt = new byte[SaltSize];
                Buffer.BlockCopy(bytes, 4, salt, 0, SaltSize);

                byte[] stored = new byte[HashSize];
                Buffer.BlockCopy(bytes, 4 + SaltSize, stored, 0, HashSize);

                byte[] computed = Pbkdf2(password, salt, iterations, HashSize);

                // Zamanlama sald&#305;r&#305;lar&#305;na kar&#351;&#305; sabit s&#252;reli kar&#351;&#305;la&#351;t&#305;rma
                int diff = 0;
                for (int i = 0; i < HashSize; i++)
                    diff |= stored[i] ^ computed[i];

                return diff == 0;
            }
            catch
            {
                return false;
            }
        }

        private static byte[] Pbkdf2(string password, byte[] salt, int iterations, int outputBytes)
        {
            using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, iterations))
                return pbkdf2.GetBytes(outputBytes);
        }
    }
}
