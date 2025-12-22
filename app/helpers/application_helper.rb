module ApplicationHelper
  def render_with_hashtags(content)
    # #から始まる文字列を、検索ページへのリンクに変換する
    content.gsub(/[#＃][\w\p{Han}\p{Hiragana}\p{Katakana}ー]+/){|word| link_to word, "/search?word=#{word.delete("#").delete("＃")}&range=Post", style: "color: #007bff; text-decoration: none;"}.html_safe
  end
end