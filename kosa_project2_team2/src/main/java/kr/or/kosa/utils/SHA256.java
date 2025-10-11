package kr.or.kosa.utils;


import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class SHA256 {
    // 임시 소금값 (salt)
    private final static String mSalt = "코스";

    // SHA-256 암호화 메서드
    public static String encodeSha256(String source) {
        String result = "";

        try {
            // 문자열과 salt를 byte 배열로 변환
            byte[] a = source.getBytes();
            byte[] salt = mSalt.getBytes();
            byte[] bytes = new byte[a.length + salt.length];

            // 문자열 + salt 합치기
            System.arraycopy(a, 0, bytes, 0, a.length);
            System.arraycopy(salt, 0, bytes, a.length, salt.length);

            // SHA-256 해시 생성
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(bytes);
            byte[] byteData = md.digest();

            // 16진수 문자열로 변환
            StringBuffer sb = new StringBuffer();
            for (int i = 0; i < byteData.length; i++) {
                sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
            }

            result = sb.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }

        return result;
    }
}
