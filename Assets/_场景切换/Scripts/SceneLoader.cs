using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

// https://www.bilibili.com/video/BV1po4y1m7VY/?spm_id_from=333.999.0.0&vd_source=c550d0c5fa86b0f88fd942018f975621
public class SceneLoader : MonoBehaviour
{
    public GameObject eventObj;
    public Button btnA;

    public Button btnB;
    public Animator animator;

    // Start is called before the first frame update
    void Start()
    {
        // 设置在场景加载过程中，挂载的对象不被销毁
        DontDestroyOnLoad(gameObject);
        DontDestroyOnLoad(eventObj);

        btnA.onClick.AddListener(LoadSceneA);
        btnB.onClick.AddListener(LoadSceneB);
    }

    private void LoadSceneB()
    {
        // 正式加载场景前会等待场景的过度动画播放完
        // 使用协程来实现这个等待过程
        StartCoroutine(LoadScene(2));
    }

    IEnumerator LoadScene(int index)
    {
        animator.SetBool("FadeIn",true);
        // 等待动画播放完
        yield return new WaitForSeconds(1);
        AsyncOperation async = SceneManager.LoadSceneAsync(index);
        // 完成时添加回调
        async.completed += OnLoadedScene;
    }

    private void OnLoadedScene(AsyncOperation obj)
    {
        animator.SetBool("FadeIn",false);
    }

    private void LoadSceneA()
    {
        StartCoroutine(LoadScene(1));
    }

    // Update is called once per frame
    void Update()
    {
    }
}