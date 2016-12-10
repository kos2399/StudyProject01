using UnityEngine;
using System.Collections;

public class can : MonoBehaviour {
    public AudioClip m_JumpSound;
    public AudioSource m_AudioSource;

    void Start()
    {
        m_AudioSource = GetComponent<AudioSource>();
        m_AudioSource.clip = m_JumpSound;
    }

    void OnCollisionEnter(Collision collision)
    {
        if (collision.collider.CompareTag("MyPlayer"))
        {
            Debug.Log("맞앗다");
           
            m_AudioSource.Play();
        }
    }
}
